sudo apt remove -y mercurial
sudo add-apt-repository -y ppa:mercurial-ppa/releases
sudo apt-get update
sudo apt-get install -y mercurial

# for using proxy
sudo pip install PySocks
sudo apt-get install -y python-socks
