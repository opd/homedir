#!/usr/bin/env bash

if [ ! -f ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

bash ~/.tmux/plugins/tpm/tpm
