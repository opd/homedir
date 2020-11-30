# vim8
set -e
sudo apt update
## vim
sudo apt install -y vim vim-nox vim-gtk3 vim-gtk flake8 pylint ack-grep
sudo pip install neovim
sudo pip3 install neovim
# vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
