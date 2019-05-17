#!/usr/bin/env python3
import argparse
import itertools
import operator as op
import os
import re
import subprocess
import sys
import tempfile

EXTENSION_BLACK_LIST = [
    'pdf',
    # fonts
    'eot', 'woff', 'otf', 'ttf',
    # images
    'jpeg', 'jpg', 'png',
    # flash
    'swf',
]


def get_project_dir_and_vcs():
    orig_path = project_path = os.getcwd()
    while True:
        for svn, folder in [('hg', '.hg'), ('git', '.git')]:
            path = os.path.join(project_path, folder)
            if os.path.exists(path) and os.path.isdir(path):
                return project_path, svn, orig_path
        project_path = os.path.dirname(project_path)
        if project_path == '/':
            return orig_path, None, orig_path


def get_regex_filter(*args, inverse=False):
    pattern = re.compile(*args)

    def func(s):
        m = pattern.match(s)
        if inverse:
            return not bool(m)
        return bool(m)
    return func


def convert_to_relative_path(lines, project_path, current_dir):
    for line in lines:
        line = project_path + '/' + line
        yield os.path.relpath(line, current_dir)


def write_file_list(
    tempfile,
    path,
    vcs_name,
    file_extensions,
    ignore_file_extensions,
    grep_patterns,
    project_path=None,
    current_dir=None,
    current_dir_only=False,
    ctrlp=None,
    path_contains=None,
    debug_flags=None,
):
    shell_cmd = ""
    if vcs_name == "hg":
        shell_cmds = ["hg status -acm"]
    elif vcs_name == "git":
        shell_cmds = [
            "git ls-tree --full-tree -r --name-only HEAD",
            "git --no-pager diff --cached --name-only",
        ]
    else:
        raise NotImplementedError

    lines = []
    for shell_cmd in shell_cmds:
        command = shell_cmd.split(' ')
        kwargs = {
            "stdout": subprocess.PIPE,
            "stderr": subprocess.DEVNULL,
        }
        p = subprocess.Popen(command, **kwargs)
        output_lines = iter(p.stdout.readline, b'')
        if vcs_name == 'hg':
            output_lines = map(op.itemgetter(slice(2, None)), output_lines)
        lines = itertools.chain(output_lines, lines)

    lines = map(lambda x: x.decode("utf-8", "replace"), lines)
    if current_dir_only:
        path = os.path.relpath(current_dir, project_path)
        lines = filter(lambda x: x.startswith(path), lines)

    func = get_regex_filter(
        ".*(%s)$" % "|".join(EXTENSION_BLACK_LIST + ignore_file_extensions),
        inverse=True,
    )
    lines = filter(func, lines)
    if file_extensions:
        func = get_regex_filter(".*(%s)$" % "|".join(file_extensions))
        lines = filter(func, lines)
    if ctrlp:
        pattern = ['.*%s' % c for c in ctrlp]
        pattern = "^%s*$" % "".join(pattern)
        func = get_regex_filter(pattern)
        lines = filter(func, lines)
    if path_contains:
        lines = filter(lambda x: path_contains in x, lines)
    for pattern in grep_patterns:
        func = get_regex_filter(pattern)
        lines = filter(func, lines)

    lines = convert_to_relative_path(lines, project_path, current_dir)

    debug_flags = debug_flags or []
    if 'files' in debug_flags:
        lines = list(lines)
        print_lines(lines)

    with open(tempfile.name, 'w') as f:
        for line in lines:
            f.write(line)


def get_width():
    result = subprocess.check_output(['tput', 'cols'])
    return int(result.decode().strip())


FILE_EXTENSIONS = [
    'sql',
    ('js', ['js', 'jsx', 'ts']),
    ('ts', ['ts', 'tsx'], ['graphql.ts']),
    ('graphql', ['graphql.ts']),
    ('css', ['css', 'scss', 'less', 'sass']),
    'html',
    'py',
    'vue',
]


def get_code_line(code_line, search_pattern, space):
    if search_pattern in code_line:
        index = code_line.index(search_pattern)
        prefix = '>'
        side_space = space - len(search_pattern) - len(prefix)
        right_side = left_side = side_space // 2
        if side_space % 2 == 1:
            left_side += 1
        left_margin = index - left_side
        right_margin = index + len(search_pattern) + right_side
        if left_margin < 0:
            right_margin += abs(left_margin)
        if right_margin > len(code_line):
            diff = right_margin - len(code_line)
            left_margin -= diff
        if left_margin < 0:
            left_margin = 0

        if left_margin == 0:
            right_margin += 1
            return code_line[:right_margin]
        return prefix + code_line[left_margin:right_margin]
    return code_line[:space]


def format_search_pattern(s):
    return s.replace('(', '\(')


def format_file_name(s):
    s = s.replace('.', '[.]')
    return s


def print_line(file_name,
               line,
               column,
               code_line,
               initial_search_pattern,
               max_length,
               min_line_length):
    # SHRINK_LINES: max_length
    # MIN_LINE_LENGTH: min_line_length
    required_data_length = len(file_name) + len(line) + len(column) + 4
    space_per_code_line = max(max_length - required_data_length, 0)
    if len(code_line) > space_per_code_line:
        label = "..%s" % len(code_line)
        label_length = len(label)
        max_code_line_length = max(min_line_length,
                                   space_per_code_line - label_length)
        code_line = get_code_line(code_line,
                                  initial_search_pattern,
                                  max_code_line_length) + label
    print("{0}:{1}:{2}:{3}".format(file_name, line, column, code_line))


def print_lines(lines):
    for line in lines:
        print(line)


def iterate_output(lines):
    for line in lines:
        line = line.decode("utf-8", "replace")
        line = line.rstrip()
        yield line.split(':', maxsplit=3)


def remove_extra_spaces(lines):
    replace_spaces_pattern = re.compile('\s+')
    for item in lines:
        file_name, row, col, code_line = item
        code_line = replace_spaces_pattern.sub(' ', code_line)
        yield file_name, row, col, code_line


def filter_max_length(data, max_line_length):
    for item in data:
        if len(item[3]) > max_line_length:
            continue
        yield item


def filter_count(data, count):
    for i, item in enumerate(data):
        yield item
        if i == count - 1:
            break


def only_count_per_file(data):
    prev_file_name = prev_line = prev_col = prev_code_line = None
    count = 1
    for item in data:
        file_name, row, col, code_line = item
        if file_name == prev_file_name:
            count += 1
        else:
            if prev_file_name is not None:
                yield (prev_file_name, prev_line,
                       prev_col + ':' + str(count), prev_code_line)
            prev_file_name = file_name
            prev_line = row
            prev_col = col
            prev_code_line = code_line
            count = 1

    if prev_file_name is None:
        raise StopIteration()

    yield (prev_file_name, prev_line,
           prev_col + ':' + str(count), prev_code_line)


class ParserFallback():
    def __init__(self, search):
        self._search = search

    def __getattr__(self, name):
        if name == 'search_pattern':
            return self._search
        return None


SCORE_PATTERNS = [
    (r'^class {0}\(.*', 200),
    (r'^def {0}\(.*', 200),
    (r'^class {0}.*', 150),
    (r'^def {0}.*', 150),
    (r'^\s+class {0}\(.*', 100),
    (r'^\s+def {0}\(.*', 100),
    (r'^\s+class {0}.*', 50),
    (r'^\s+def {0}.*', 50),
]


def compile_score_patterns(score_patterns, search_pattern):
    return [
        (re.compile(pattern.format(search_pattern)), score)
        for (pattern, score) in score_patterns
    ]


def add_first_item(items, item):
    yield item
    yield from items


class ScoreFunc:
    def __init__(self, patterns):
        self._patterns = patterns
        self._max_score = max(x[1] for x in self._patterns)

    def __call__(self, s):
        patterns = self._patterns
        s = s[3]
        r = ((p.match(s), score) for (p, score) in patterns)
        r = (s for (b, s) in r if b)
        return self._max_score - max(add_first_item(r, 0))


def get_first_n_items(items, count):
    bulk = []
    count -= 1
    for i, item in enumerate(items):
        bulk.append(item)
        if i >= count:
            break
    return bulk


def order_by_priority(lines, count=None, search_pattern=None):
    first_items = get_first_n_items(lines, count)
    patterns = compile_score_patterns(SCORE_PATTERNS, search_pattern)
    func = ScoreFunc(patterns)
    first_items = sorted(first_items, key=func)
    yield from first_items
    yield from lines


def is_simple_pattern(pattern):
    return bool(re.match(r"^[A-Za-z0-9_]+$", pattern))


class ArgumentParser(argparse.ArgumentParser):

    def error(self, message):
        raise ValueError


def main():
    parser = ArgumentParser(conflict_handler='resolve')
    parser.add_argument('search_pattern')
    parser.add_argument('--mig', dest='migrations', action='store_true')
    parser.add_argument('--class', dest='class_', action='store_true')
    parser.add_argument('--def', dest='def_', action='store_true')
    parser.add_argument('-w', dest='word', action='store_true')
    parser.add_argument('-i', dest='ignorecase', action='store_true')
    parser.add_argument('--urls', dest='urls', action='store_true')
    parser.add_argument('--views', dest='views', action='store_true')
    parser.add_argument('--models', dest='models', action='store_true')
    parser.add_argument('--count', dest='count', action='store_true')
    parser.add_argument('--cur-dir', dest='cur_dir', action='store_true')
    parser.add_argument('--cp', dest='ctrlp')
    parser.add_argument('--pc', dest='path_contains')
    parser.add_argument('--debug', nargs='*')

    file_extensions = []
    for pattern in FILE_EXTENSIONS:
        if not isinstance(pattern, str):
            pattern = pattern[0]
        parser.add_argument('--' + pattern, dest=pattern, action='store_true')

    try:
        params = parser.parse_args()
    except ValueError:
        search = " ".join(sys.argv[1:])
        params = ParserFallback(search)

    debug_flags = set([] if params.debug is None else params.debug)

    file_extensions = []
    ignore_file_extensions = []
    grep_patterns = []
    file_name = ''

    for pattern in FILE_EXTENSIONS:
        if isinstance(pattern, str):
            arr = [pattern]
        else:
            exclude_arr = None
            if len(pattern) == 3:
                pattern, arr, exclude_arr = pattern
            else:
                pattern, arr = pattern
        if getattr(params, pattern):
            file_extensions.extend(arr)
            if exclude_arr:
                ignore_file_extensions.extend(exclude_arr)

    if params.migrations:
        grep_patterns.append('.*\/[0-9]{4}[^/]+[.]py$')
    if params.urls:
        file_name = '.*\/urls[.]py'
        grep_patterns.append(file_name)
    if params.views:
        file_name = '.*\/views[.]py'
        grep_patterns.append(file_name)
    if params.models:
        file_name = '.*\/models[.]py'
        grep_patterns.append(file_name)

    path, vcs_name, current_dir = get_project_dir_and_vcs()
    file_list = None
    if vcs_name:
        file_list = tempfile.NamedTemporaryFile()
        write_file_list(
            file_list,
            path,
            vcs_name,
            file_extensions,
            ignore_file_extensions,
            grep_patterns,
            ctrlp=params.ctrlp,
            project_path=path,
            current_dir=current_dir,
            current_dir_only=params.cur_dir,
            path_contains=params.path_contains,
            debug_flags=debug_flags,
        )

    whole_word = params.word
    command = 'ack -s --noheading --column --nocolor'
    default_ignore_directories = [
        'node_modules',
        '.direnv',
    ]
    default_ignore_extensions = [
        'png',
        'jpg',
    ]
    if not vcs_name:
        for path in default_ignore_directories:
            command += " --ignore-dir=%s" % path
        for ext in default_ignore_extensions:
            command += " --ignore-file=ext:%s" % ext
    if params.ignorecase:
        command += ' -i'
    if file_list:
        command += ' --files-from=%s' % file_list.name

    additional_words = []

    search_pattern = params.search_pattern
    if '@' in search_pattern:
        additional_words = search_pattern.split('@')
        search_pattern = additional_words.pop(0)
    initial_search_pattern = search_pattern
    search_pattern = format_search_pattern(search_pattern)
    if params.class_:
        search_pattern = '^\s*class\s+' + search_pattern
        if params.word:
            whole_word = False
            search_pattern += '\s*\('
    if params.def_:
        search_pattern = '^\s*def\s+' + search_pattern
        if params.word:
            whole_word = False
            search_pattern += '\s*\('
    if whole_word:
        command += ' -w'

    LIMIT = 9999
    SHRINK_LINES = 80
    # max line length
    MAX_LINES = 200
    ADJUST_COLUMNS = True
    VIM_MARGIN = 8
    VIM_MARGIN_TWO_ROWS = 12
    MIN_LINE_LENGTH = 10
    TWO_ROWS = True

    ORDER_LINES_COUNT = 800

    if ADJUST_COLUMNS:
        if TWO_ROWS:
            SHRINK_LINES = get_width() * 2 - VIM_MARGIN_TWO_ROWS
        else:
            SHRINK_LINES = get_width() - VIM_MARGIN

    command = command.split(' ')
    command.append(search_pattern)
    kwargs = {
        "stdout": subprocess.PIPE,
        "stderr": subprocess.DEVNULL,
    }
    p = subprocess.Popen(command, **kwargs)

    lines = iter(p.stdout.readline, b'')
    lines = iterate_output(lines)

    def filter_additional_words(line_item):
        s = line_item[3]
        for word in additional_words:
            if word not in s:
                return False
        return True
    if additional_words:
        lines = filter(filter_additional_words, lines)

    lines = filter_max_length(lines, MAX_LINES)

    search_pattern = params.search_pattern
    if is_simple_pattern(search_pattern):
        lines = order_by_priority(lines, count=ORDER_LINES_COUNT,
                                  search_pattern=params.search_pattern)
    lines = remove_extra_spaces(lines)
    if params.count:
        lines = only_count_per_file(lines)
    lines = filter_count(lines, LIMIT)

    for file_name, line, column, code_line in lines:
        print_line(file_name, line, column, code_line,
                   initial_search_pattern, SHRINK_LINES, MIN_LINE_LENGTH)


if __name__ == "__main__":
    main()
