#!/bin/bash
#set -e
# aptitude
sudo apt update
sudo apt install -y aptitude software-properties-common git curl

bash -x setup/vim.sh
bash -x setup/vim-xkb-switch.sh
bash -x setup/python.sh
# bash -x setup/nerdfont.sh
bash -x setup/tmux.sh
# bash -x setup/keepass2.sh
bash -x setup/keepassx.sh
# bash -x setup/urxvt.sh
bash -x setup/ranger.sh

# base16 colors
# colors
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

# TODO add -y option !!!
bash -x copy_files_to_home.sh

vim +PlugInstall +qall!
# TODO update remote plugins

# это должно быть в последнюю очередь!!
# zsh and etc
sudo apt install -y zsh tmux direnv
rm -rf ~/.oh-my-zsh
# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

bash -x copy_files_to_home.sh

echo logout, login and type "base16_monokai"
