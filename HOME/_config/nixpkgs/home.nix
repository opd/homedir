{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "a";
  home.homeDirectory = "H0Me";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
  home.packages = [
    # svn
    pkgs.gh
    pkgs.git
    pkgs.delta
    pkgs.git-lfs
    # utils
    pkgs.htop
    # editor
    pkgs.neovim
    pkgs.jq
    # other
    pkgs.gcc
    pkgs.docker-compose
    pkgs.pre-commit
    pkgs.pgformatter
    pkgs.pspg
    pkgs.ack
    pkgs.rsync
    pkgs.sqlite
    pkgs.tmux
    pkgs.watchman
    ### cloud
    pkgs.amazon-ecr-credential-helper
    pkgs.aws-vault
    pkgs.awscli2
    pkgs.awslogs
    pkgs.chamber
    pkgs.packer
    pkgs.ssm-session-manager-plugin
    ### js
    pkgs.nodejs-14_x
    # pkgs.nvm
    pkgs.yarn
    # python
    pkgs.direnv
    pkgs.black
    pkgs.pipenv
    pkgs.python39Packages.flake8
    pkgs.python39Packages.isort
    pkgs.python39Packages.pip
    pkgs.python39Full
    # python2
    # pkgs.python27Packages.withPackages(p: with p; [ p.virtualenv ])
    # pkgs.python27Full.withPackages
    # pkgs.python27Packages.virtualenv
  ];
}
