sudo dpkg --add-architecture i386
. /etc/os-release
echo $UBUNTU_CODENAME
if [ "$ID" != "linuxmint" ] ; then
        exit 1
fi
sudo apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $UBUNTU_CODENAME main"
sudo apt-get update
sudo apt-get install -y --install-recommends winehq-stable
