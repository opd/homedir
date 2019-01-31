sudo apt remove --purge silversearcher-ag
sudo apt install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
git clone --depth=1 https://github.com/ggreer/the_silver_searcher
cd the_silver_searcher
./build.sh
sudo make install
