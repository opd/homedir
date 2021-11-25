#!/usr/bin/bash
#sudo apt update
#sudo apt dist-upgrade -y
#sudo apt install curl
#curl -L https://nixos.org/nix/install | sh
#cd ~
#. ~/.nix-profile/etc/profile.d/nix.sh
#nix-channel --update
#nix-shell -p git --run "git clone https://github.com/opd/homedir.git"
#cd homedir
#./copy_files_to_home.sh -y
#source ~/.bashrc

# Installing home manager
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --update
# export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
# nix-shell '<home-manager>' -A install

# home-manager switch

# Install wrapper
# nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl && nix-channel --update
# nix-env -iA nixgl.auto.nixGLDefault

# ssh-keygen -t rsa -f ~/.ssh/id_rsa_github
# gh auth login --web
# gh auth refresh -h github.com -s admin:public_key
# gh ssh-key add ~/.ssh/id_rsa_github.pub --title $(hostname)
# cd ~/homedir
# git remote set-url origin git@github.com:opd/homedir.git
