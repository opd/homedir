import pytest

from format_python import (is_line_empty, space_count_before, remove_bounding_blank_lines)


def test_format_python():
    assert space_count_before('   3') == 3


@pytest.mark.parametrize(
    'case',
    [
        ("     \n", True),
        ("\n", True),
        ("asdf\n", False),
        ("    asdf\n", False),
        ("    asdf    \n", False),
    ]
)
def test_is_line_empty(case):
    line, result = case
    assert is_line_empty(line) == result


def test_remember_blank_lines():
    data = [
        '\n', '  \n', ' \n',
        '1\n', '2\n',
        '\n', ' \n',
        '3\n',
        '  \n',
        '4\n',
        ' \n', '\n', '   \n', '\n', '\n',
    ]
    lines = iter(data)
    result = []
    lines = remove_bounding_blank_lines(lines, result)
    lines = list(lines)
    assert lines == [
        '1\n', '2\n',
        '\n', '\n',
        '3\n',
        '\n',
        '4\n',
    ]
    assert result == [3, 5]


def test_remember_blank_lines_no_blank():
    data = [
        '1\n', '2\n',
        '\n', ' \n',
        '3\n',
        '  \n',
        '4\n',
    ]
    lines = iter(data)
    result = []
    lines = remove_bounding_blank_lines(lines, result)
    lines = list(lines)
    assert lines == [
        '1\n', '2\n',
        '\n', '\n',
        '3\n',
        '\n',
        '4\n',
    ]
    assert result == [0, 0]
