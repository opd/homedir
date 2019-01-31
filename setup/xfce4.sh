# download nerd font
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
./nerd-fonts/install.sh DroidSansMono
# paper theme
sudo add-apt-repository -y ppa:snwh/pulp
# default gnome profile
sudo apt-get install -y dconf-cli
defprofile=$(dconf read /org/gnome/terminal/legacy/profiles:/default)
defprofile=${defprofile%\'}
defprofile=${defprofile#\'}
echo $defprofile
dconf write /org/gnome/terminal/legacy/profiles:/:$defprofile/font "'DroidSansMonoForPowerline Nerd Font 10'"
dconf write /org/gnome/terminal/legacy/profiles:/:$defprofile/use-system-font false
# HIDE menu by default
dconf write /org/gnome/terminal/legacy/default-show-menubar false
# xfce4
sudo apt-get install -y xfce4 paper-icon-theme paper-gtk-theme paper-cursor-theme xfce4-goodies xfce4-session
#apply theme
#xfconf-query -c xsettings -p /Net/ThemeName -s "Paper"
#xfconf-query -c xsettings -p /Net/IconThemeName -s "Paper"
#xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Paper"
# OXSI square buttons theme
wget -O theme.tar.gz https://dl.opendesktop.org/api/files/download/id/1460765793/169491-OSXI%20Square%20Buttons.tar.gz
mkdir -p ~/.local/share/themes
tar -xzvf theme.tar.gz -C ~/.local/share/themes
#xfconf-query -n -t "string" -c xfwm4 -p /general/theme -s "OSXI Square Buttons"
sudo apt-get install -y xfce4-goodies
