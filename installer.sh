#!/bin/bash
echo "Make virtualenv"
python3 -m venv env
source env/bin/activate
# TODO install dependencies
echo "Run script"
python bin/installer.py
