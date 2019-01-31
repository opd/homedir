# HomeDir
sudo apt-get install git

git clone https://github.com/opd/HomeDir.git 

Comment out the line `dns=dnsmask` in /etc/NetworkManager/NetworkManager.conf

Restart Network Manager

`sudo service network-manager restart`

HomeDir/setup.sh
