#!/usr/bin/env python3
import fileinput
from subprocess import DEVNULL, check_call, CalledProcessError
import sys
import tempfile


TEMP_DIR = tempfile.gettempdir()

BEFORE_MARK = "LALA"
MARK = "OLOLO"


def get_input_data():
    for line in fileinput.input():
        yield line


def space_count_before(line):
    for i, c in enumerate(line):
        if c != ' ':
            return i


def handle_indentation(lines, indent_width=4):
    for i, line in enumerate(lines):
        if i == 0:
            space_count = space_count_before(line)
            indent_count = space_count // indent_width
            for i in range(indent_count):
                if i == 0:
                    s = "def f(a='%s')" % BEFORE_MARK
                else:
                    s = " " * indent_width * i + 'if '
                    if i == indent_count - 1:
                        s += "'%s'" % MARK
                    else:
                        s += "'%s'" % BEFORE_MARK
                s += ':\n'
                yield s
        yield line


def handle_dummy_indentation(lines):
    lines = iter(lines)
    for line in lines:
        if MARK in line:
            break

        if BEFORE_MARK not in line:
            yield line
            break
    for line in lines:
        yield line


def write_lines_to_file(lines, filename):
    with open(filename, 'w') as f:
        for line in lines:
            f.write(line)


def read_lines_from_file(filename):
    with open(filename, 'r') as f:
        for line in f:
            yield line


def run_black(fname):
    check_call(['black', fname], stdout=DEVNULL, stderr=DEVNULL)


def run_2to3(fname):
    fixers = ['print', 'apply', 'ne', 'paren', ]
    cmd = ['2to3', '-w']
    for fixer in fixers:
        cmd += ['-f', fixer]
    cmd += [fname]
    check_call(cmd, stdout=DEVNULL, stderr=DEVNULL)


def check_valid(fname):
    cmd = ['python3', '-m', 'py_compile', fname]
    try:
        check_call(cmd, stdout=DEVNULL, stderr=DEVNULL)
    except CalledProcessError:
        return False
    return True


def is_line_empty(line):
    for char in line:
        if char not in ' \n':
            return False
    return True


def remove_bounding_blank_lines(lines, result):
    first_lines = True
    empty_line_count = 0
    for line in lines:
        if is_line_empty(line):
            empty_line_count += 1
        else:
            if first_lines:
                result.append(empty_line_count)
                empty_line_count = 0
                first_lines = False
            for _ in range(empty_line_count):
                yield '\n'
            empty_line_count = 0
            yield line
    result.append(empty_line_count)


def add_bounding_blank_lines(lines, before_count, after_count):
    for _ in range(before_count):
        yield '\n'
    for line in lines:
        yield line
    for _ in range(after_count):
        yield '\n'


def main():
    input_lines = get_input_data()
    bounding_lines = []
    input_lines = remove_bounding_blank_lines(input_lines, bounding_lines)
    input_lines = handle_indentation(input_lines)

    tmp_file = tempfile.NamedTemporaryFile()
    tmp_fname = tmp_file.name
    tmp_fname = '/tmp/file.txt'

    write_lines_to_file(input_lines, tmp_fname)

    # run_2to3(tmp_fname)
    if check_valid(tmp_fname):
        run_black(tmp_fname)

    result_lines = read_lines_from_file(tmp_fname)
    result_lines = handle_dummy_indentation(result_lines)
    result_lines = remove_bounding_blank_lines(result_lines, [])
    result_lines = add_bounding_blank_lines(result_lines, *bounding_lines)

    for line in result_lines:
        sys.stdout.write(line)


if __name__ == "__main__":
    main()
