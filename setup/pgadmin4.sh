# Don't work properly, cannot connect server, maybe postgresql issue
sudo apt install -y python3-dev python3-venv python-pip postgresql-common libpq-dev wget
cd ~
pyvenv-3.5 .pgadmin4
cd ~/.pgadmin4/
source bin/activate
wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v2.1/pip/pgadmin4-2.1-py2.py3-none-any.whl
pip install wheel flask
pip install pgadmin4*.whl
cd ~/.pgadmin4/lib/python3.5/site-packages/pgadmin4/
sed -i -- 's/SERVER_MODE = True/SERVER_MODE = False/g' config.py
python ~/.pgadmin4/lib/python3.5/site-packages/pgadmin4/setup.py

python ~/.pgadmin4/lib/python3.5/site-packages/pgadmin4/pgAdmin4.py
