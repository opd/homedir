# vim8
sudo apt-get remove -y vim
# for old Ubuntu 16.04 
# sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt-get update
## vim
# sudo apt-get install -y vim vim-nox vim-gnome vim-gtk flake8 pylint ack-grep
sudo apt-get install -y vim vim-nox vim-gtk3 vim-gtk flake8 pylint ack-grep
sudo pip install neovim
sudo pip3 install neovim
# vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
