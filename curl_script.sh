#!/bin/bash
read -s -p "Enter password from Github: " PASSWORD
echo ""
read -p "Enter Github key title: " KEY_TITLE
sudo apt install -y curl git
cat /dev/zero | ssh-keygen -q -N ""
curl -u "opd:$PASSWORD" --data '{"title":"$KEY_TITLE","key":"'"$(cat ~/.ssh/id_rsa.pub)"'"}' https://api.github.com/user/keys
# known hosts
ssh-keyscan -t rsa -H github.com >> ~/.ssh/known_hosts
cd ~
git clone git@github.com:opd/homedir.git
cd ~/homedir/
sh setup.sh
