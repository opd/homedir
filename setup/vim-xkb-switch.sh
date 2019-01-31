git clone https://github.com/ierton/xkb-switch
sudo apt-get install -y libxkbfile-dev cmake build-essential
cd xkb-switch
mkdir build && cd build
cmake ..
make
sudo make install
