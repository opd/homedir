#!/bin/bash
read -s -p "Enter github token: " github_oauth_token
echo ""
read -p "Enter Github key title: " KEY_TITLE
echo ""
sudo apt install -y curl git
# TODO run only if no keys exists
cat /dev/zero | ssh-keygen -q -N ""
curl --header "Authorization: token $github_oauth_token"  --data '{"title":"'"$KEY_TITLE"'","key":"'"$(cat ~/.ssh/id_rsa.pub)"'"}' 'https://api.github.com/user/keys'

# # known hosts
ssh-keyscan -t rsa -H github.com >> ~/.ssh/known_hosts

sudo snap install --edge gh
gh auth login -h github.com -w
gh api https://api.github.com/user/keys

# cd ~
# git clone git@github.com:opd/homedir.git
# cd ~/homedir/
# sh setup.sh
