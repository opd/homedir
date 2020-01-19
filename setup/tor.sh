#!/bin/bash
# DEPS
sudo apt install curl -y

DOWNLOAD_DIR="/tmp/"
FNAME="tor.tar.xz"

line_with_link=$(curl -s https://www.torproject.org/download/ | grep -e 'href=".*linux.*\.tar\.xz"')
link=$(echo $line_with_link | sed -n -e 's/.*href="\([^"]*\)".*/\1/p')
link="https://www.torproject.org$link"
echo $link
curl -L $link --output $DOWNLOAD_DIR$FNAME
tar xf $DOWNLOAD_DIR$FNAME -C ~/Downloads/
