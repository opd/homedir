#!/bin/bash

# set terminal font
dconf write /org/gnome/terminal/legacy/profiles:/:aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/visible-name "'coding'"
dconf write /org/gnome/terminal/legacy/profiles:/list "['aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee']"
dconf write /org/gnome/terminal/legacy/profiles:/:aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/use-system-font false
dconf write /org/gnome/terminal/legacy/profiles:/:aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/font "'DroidSansMono Nerd Font 11'"
dconf write /org/gnome/terminal/legacy/default-show-menubar false

# Set languages
dconf write /org/gnome/desktop/input-sources/sources "[('xkb', 'us'), ('xkb', 'ru')]"
dconf write /org/gnome/desktop/input-sources/xkb-options "['grp:alt_shift_toggle']"
