# for user
sudo apt-get install -y python-pip python3-pip
sudo pip install --upgrade pip
sudo pip install setuptools
sudo pip3 install --upgrade pip
sudo pip3 install setuptools
pip install --user virtualenvwrapper
sudo pip2 install virtualenvwrapper
# Ubuntu 16.04 python 3.6
# sudo add-apt-repository -y ppa:jonathonf/python-3.6
# sudo apt update
# sudo apt install python3.6

# for vim
sudo apt install exuberant-ctags

# pyenv
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev
# sudo apt install direnv
curl -sfL https://direnv.net/install.sh | bash
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
pyenv update
pyenv install 3.6.5
echo Run manually 'pyenv update'

