# for user
set -e
# sudo apt install -y python3-pip curl python-is-python3
# curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
# python2 get-pip.py

pip2 install setuptools
sudo pip3 install --upgrade pip
sudo pip3 install setuptools
pip2 install --user virtualenvwrapper
pip2 install virtualenvwrapper

# for vim
sudo apt install exuberant-ctags

# pyenv
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev
# sudo apt install direnv
curl -sfL https://direnv.net/install.sh | bash
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
pyenv update
pyenv install 3.6.5
sudo apt install -y pipenv
# TODO install python2.7 install py2venv
echo Run manually 'pyenv update'

