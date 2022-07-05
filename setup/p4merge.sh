exit 0
# https://www.perforce.com/downloads/visual-merge-tool
# http://blogs.pdmlab.com/alexander.zeitler/articles/installing-and-configuring-p4merge-for-git-on-ubuntu/
tar zxvf p4v.tgz
sudo mkdir /opt/p4merge
sudo mv * /opt/p4merge
sudo ln -s /opt/p4merge/bin/p4merge /usr/local/bin/p4merge
