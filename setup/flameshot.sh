sudo apt install g++ build-essential qt5-default qt5-qmake qttools5-dev-tools libqt5svg5-dev
mkdir -p ~/from_source
cd ~/from_source
git clone --branch master --single-branch --depth 1 https://github.com/lupoDharkael/flameshot.git
cd flameshot
mkdir build
cd build
qmake ../
make
sudo make install
