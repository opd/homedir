#!/bin/bash

echo "Starting tor"
~/Downloads/tor-browser_en-US/Browser/start-tor-browser --detach
# Start tor for proxy
while : ; do
   curl -s -I --socks5 localhost:9150  http://google.com
   if [ $? -eq 0 ]; then
      break
   fi
   echo "Sleep untill tor proxy"
   sleep 3
done

DOWNLOAD_DIR="/tmp/"
FNAME="telegram.tar.xz"

curl -L --socks5 localhost:9150 https://telegram.org/dl/desktop/linux --output $DOWNLOAD_DIR$FNAME
tar xf $DOWNLOAD_DIR$FNAME -C ~/Downloads/
~/Downloads/Telegram/Telegram &
