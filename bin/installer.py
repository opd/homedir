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
    return files

def err_message(s):
    print("ERROR:", s)

def get_script_lines(data):
    lines = []
    # TODO temp code
    data = list(data.values())[0]
    if 'apt' in data:
        packages = " ".join(data['apt'])
        lines.append(f'sudo apt install -y {packages}')
    if 'script' in data:
        lines.append(data['script'])
    return lines

def install(packages):
    files = scan()
    package = packages[0]
    if package not in files:
        err_message(f"Unknown package {package}")
        return
    # TODO deps
    lines = get_script_lines(files[package])
    data = "\n".join(lines)
    print(data)
    pass

parser = argparse.ArgumentParser(description="Installer.")
parser.add_argument('--scan', action="store_true")
parser.add_argument('--install', type=str, nargs='*')

args = parser.parse_args()
if args.scan:
    scan()
elif args.install:
    install(args.install)
