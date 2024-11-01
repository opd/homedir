import traceback
import sys

from typing import Any

def _path_satisfy(path):
    return '/.' not in path

def _get_traceback_paths(last_traceback):
    # Extract traceback details
    traceback_info = traceback.extract_tb(last_traceback)
    # Collect the file paths from each frame
    paths = [frame.filename for frame in traceback_info]
    return paths


def up_to_git(file=None):
    paths = _get_traceback_paths(sys.last_traceback)
    paths = reversed(paths)
    value = next((i for i, s in enumerate(paths) if _path_satisfy(s)), None)
    print(value)

def flatten_dict(data: dict[str, Any] | list[dict[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    if isinstance(data, dict):
        items = data.items()
    elif isinstance(data, list):
        items = [(str(i), x) for i, x in enumerate(data)]
    else:
        # TODO fix
        raise BaseException("Obj should be dict or list")
    for key, value in items:
        if isinstance(value, dict | list):
            for nested_key, nested_value in flatten_dict(value).items():  # pyright: ignore
                result[key + "." + nested_key] = nested_value
        else:
            result[key] = value
    return result

def cmp(first, second):
    first = flatten_dict(first)
    second = flatten_dict(second)
    keys = sorted(first.keys() | second.keys())
    for key in keys:
        if key not in first:
            print(f"No key '{key}' in first")
            continue
        if key not in second:
            print(f"No key '{key}' in second")
            continue
        a = first.get(key)
        b = second.get(key)
        if a != b:
            print(f"{key}: ['{a}','{b}']")
