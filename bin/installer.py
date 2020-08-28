import argparse
from pathlib import Path

import yaml

PROJECT_ROOT = (Path(__file__) / "../..").resolve()
SCRIPTS_ROOT = PROJECT_ROOT / "setup"

def get_yaml_filenames():
    file_list = []
    for f in SCRIPTS_ROOT.iterdir():
        if f.is_file() and f.suffix == '.yml':
            file_list.append(f)
    return file_list

def get_files(files):
    result = {}
    for fname in files:
        with open(fname) as file:
            data = yaml.load(file, Loader=yaml.FullLoader)
            result[fname.stem] = data
    return result

def scan():
    files = get_yaml_filenames()
    files = get_files(files)
    print(files)
    pass

parser = argparse.ArgumentParser(description="Installer.")
parser.add_argument('scan', type=bool)

args = parser.parse_args()
if args.scan:
    scan()
