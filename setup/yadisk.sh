#!/bin/bash
echo "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/yandex-disk.list > /dev/null
wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y yandex-disk

echo "Copy files to git then"
echo "yandex-disk token <yandex-username>"
echo "yandex-disk start"

# НЕ РАБОТАЕТ
#sudo add-apt-repository ppa:slytomcat/ppa -y
#sudo apt-get update
#sudo apt-get install -y yd-tools
# TODO prompt username
# yandex-disk token USERNAME
