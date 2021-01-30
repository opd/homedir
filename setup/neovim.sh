curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mkdir -p ~/.bin
mv ./nvim.appimage ~/.bin

PYTHON2=2.7.18
PYTHON3=3.8.2

pyenv install -s $PYTHON2
pyenv install -s $PYTHON3

pyenv virtualenv $PYTHON2 neovim2
pyenv virtualenv $PYTHON3 neovim3

pyenv activate neovim2
pip install neovim
source deactivate
pyenv activate neovim3
pip install neovim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# pyenv shell 2.7.18
# pip install neovim
# pyenv shell 3.8.2
# pip install neovim
