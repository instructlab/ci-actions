# SPDX-License-Identifier: Apache-2.0

"""
This script validates a Jupyter notebook file.
Usage: python validate_notebook.py <notebook.ipynb>
"""

# Standard
from pathlib import Path
import argparse
import os
import sys

# Third Party
import nbformat


def validate_notebook(file_path) -> bool:
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            nb = nbformat.read(f, as_version=4)
        nbformat.validate(nb)
        print(f"{file_path} is a valid Jupyter notebook.")
        return True
    except nbformat.ValidationError as e:
        print(f"{file_path} is not a valid Jupyter notebook. Validation error: {e}")
        return False


def list_valid_files(paths: list) -> list:
    """
    list valid files finds and returns a list of .ipynb files in the given list of paths
    """

    all_files = []
    for path in paths:
        if not os.path.exists(path):
            print(f"invalid path {path}: path does not exist")
            continue
        if os.path.isfile(path):
            if ".ipynb" not in path:
                print(
                    f"invalid path {path}: files must be ipython notebooks"
                )  # fatal error: files must be .ipynb
                sys.exit(1)
            all_files.append(path)
        elif os.path.isdir(path):
            search_dir = Path(path)
            discovered_notebook_files = search_dir.rglob("*.ipynb")
            for file in discovered_notebook_files:
                all_files.append(file)
    return all_files


if __name__ == "__main__":
    invalid_notebook_found = False
    parser = argparse.ArgumentParser(
        description="validates jupyter notebook files by checking the underlying JSON. This will not run the notebooks."
    )
    parser.add_argument(
        "path",
        metavar="path",
        type=str,
        nargs="+",
        help="a path to an .ipynb file, or a directory containing .ipynb files",
    )
    args = parser.parse_args()
    if len(args.path) < 1:
        print("must provide at least one path")
        sys.exit(1)

    user_provided_paths = list_valid_files(args.path)
    if len(user_provided_paths) < 1:
        print("no valid file paths to jupyter notebooks provided")
        sys.exit(1)

    for user_path in user_provided_paths:
        ok = validate_notebook(user_path)
        if not ok:
            invalid_notebook_found = True

    if invalid_notebook_found:
        sys.exit(1)  # indicate to ci environment that something failed
