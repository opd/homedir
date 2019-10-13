#!/bin/bash
sudo apt update
sudo apt install -y python3-pip python3-apt python-apt
sudo pip3 install ansible
ansible-playbook playbook.yml --ask-become-pass
