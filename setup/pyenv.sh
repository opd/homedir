#!/bin/bash
# Так.. как pyenv установлен
sudo apt install -y python-is-python3
# curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

# TODO install pyenv 2.7
pyenv shell 2.7.18
pip install py2venv
