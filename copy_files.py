#!/usr/bin/env python3
import argparse
import datetime
from pathlib import Path
import shutil

PROJECT_DIR = Path(__file__).resolve().parent
HOME_ALIAS = "H0Me"

class NoSourceFile(BaseException):
    pass

def get_paths(path: Path, ignored_paths: list[Path]) -> list[Path]:
    """ Recursively find all files in 'path' and return a list of file paths, ignoring specified paths and their subdirectories. """
    all_files = []
    
    # Normalize ignored paths for comparison
    ignored_paths = [(path / ignore).resolve() for ignore in ignored_paths]
    
    for item in path.rglob('*'):
        # Check if item is within any of the ignored paths
        if item.is_file() and not any(item.resolve().is_relative_to(ignore) for ignore in ignored_paths):
            all_files.append(item)
    
    return all_files

def copy_and_modify_file(source: Path, destination: Path, backup: Path | None=None, replacements: dict[str, str] | None = None):
    """Copy file from source to destination with modifications.

    If the destination already has a file, save the current destination file to the backup path.
    The function will perform replacements on the file content before copying.
    
    Parameters:
    - source: Path of the source file to copy.
    - destination: Path where the file should be copied.
    - backup: Path where the backup of the existing destination file (if any) should be saved.
    - replacements: Dictionary of replacements to apply {old_text: new_text}.
    """

    if not source.exists():
        raise NoSourceFile
    
    # Read the file content from source, apply replacements, and write to destination
    with source.open('r', encoding='utf-8') as f:
        content = f.read()
    
    # Perform replacements
    for old_text, new_text in replacements.items():
        content = content.replace(old_text, new_text)

    # Check if the destination file exists
    if backup and destination.exists():
        with destination.open('r', encoding='utf-8') as f:
            dest_content = f.read()
        if dest_content != content:
            # Create the backup directory if it doesn't exist
            backup.parent.mkdir(parents=True, exist_ok=True)
            # Copy the existing destination file to the backup path
            shutil.copy2(destination, backup)
    
    # Write modified content to the destination file
    with destination.open('w', encoding='utf-8') as f:
        f.write(content)


def get_files_list(path):
    def is_valid_path(p):
        name = p.name
        if name[0] == '.':
            return False
        return True

    ignored_paths = [Path('.git')]
    paths = get_paths(path, ignored_paths)
    paths = [p.relative_to(path) for p in paths]
    paths = [p for p in paths if is_valid_path(p)]
    return paths

def convert_git_path(path):
    name = str(path)
    if name[0] == '_':
        name = '.' + name[1:]
    return Path(name)

def copy_files_to_git(*, source_path, dest_path, home_dir):
    file_list = get_files_list(dest_path)
    for path in file_list:
        from_ = source_path / convert_git_path(path)
        to = dest_path / path
        replacements = {
            str(home_dir): HOME_ALIAS,
        }
        try:
            copy_and_modify_file(from_, to, replacements=replacements)
        except NoSourceFile:
            dest_path.unlink()
            print('"{path}" deleted'.format(path=path))
            continue


def copy_files_to_home(*, source_path, dest_path, home_dir):
    file_list = get_files_list(source_path)
    for path in file_list:
        from_ = source_path / path
        to = dest_path / convert_git_path(path)
        backup = get_backup_directory_path() / path
        replacements = {
            HOME_ALIAS: str(home_dir),
        }
        copy_and_modify_file(from_, to, backup=backup, replacements=replacements)


def get_backup_directory_path():
    dt = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    result = PROJECT_DIR / "backup_{dt}".format(dt=dt)
    return result


def main():
    git_path = PROJECT_DIR / "HOME"
    home_path = Path.home()

    backup_path = get_backup_directory_path()
    # Create the ArgumentParser object
    parser = argparse.ArgumentParser(description='This is a simple example of using argparse.')
    parser.add_argument('--to-git', action='store_true', default=False, help='Copy to git')
    parser.add_argument('--to-home', action='store_true', default=False, help='Copy to home')

    # Parse the arguments
    args = parser.parse_args()
    assert args.to_git or args.to_home, '--to-git ro --to-home is required'

    if args.to_git:
        copy_files_to_git(source_path=home_path, dest_path=git_path, home_dir=home_path)
    elif args.to_home:
        copy_files_to_home(source_path=git_path, dest_path=home_path, home_dir=home_path)

    print(args)



if __name__ == "__main__":
    main()


