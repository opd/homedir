# https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0
sudo apt install unzip curl -y
curl -L -o /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
mkdir -p ~/.fonts/FiraCode/
unzip /tmp/FiraCode.zip -d ~/.fonts/FiraCode
