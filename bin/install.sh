#!/bin/bash

DIR=$(dirname ${BASH_SOURCE[0]})
cd $DIR
cd ..
# ?????
cd bin

echo $PWD
# 
# sudo apt update
# sudo apt install curl -y
# ./setup/nodejs.sh
# ./setup/yarn.sh
# 
# yarn install
# 
# python3 -m venv installer-venv
source installer-venv/bin/activate
# pip install -r requirements.txt

python installer.py "$@"
