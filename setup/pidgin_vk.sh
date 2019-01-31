hg clone https://bitbucket.org/olegoandreev/purple-vk-plugin
sudo apt-get install -y g++ cmake libpurple-dev libxml2-dev
cd purple-vk-plugin/build
cmake ..
make
sudo make install
