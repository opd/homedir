# audio mixer
sudo apt-get install -y pavucontrol

# tree -L 3 . # show file tree
sudo apt-get install tree

#
sudo apt-get install postgresql

#Шипение pulseaudio
Откроем файл /etc/pulse/default.pa
Найдем в нем строчку:
load-module module-udev-detect
и заменим ее на:
load-module module-udev-detect tsched=0
