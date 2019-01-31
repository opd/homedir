sudo apt update
sudo apt install -y postgresql postgresql-contrib postgresql-server-dev-all
sudo su - postgres -c "createuser $USER -s"
createdb $USER
