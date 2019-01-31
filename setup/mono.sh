# linux mint..
. /etc/os-release
echo $UBUNTU_CODENAME
if [ "$ID" != "linuxmint" ] ; then
    exit 1
fi
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/mono-official.list
sudo apt-get update
sudo apt-get install -y mono-devel
