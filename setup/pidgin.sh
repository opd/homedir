sudo add-apt-repository -y ppa:nilarimogard/webupd8
sudo apt-get update
sudo apt-get install -y pidgin telegram-purple pidgin-libnotify
sudo apt-get install -y libpurple-dev libjson-glib-dev libglib2.0-dev libpurple-dev
git clone git://github.com/EionRobb/purple-discord.git
cd purple-discord
make
sudo make install
