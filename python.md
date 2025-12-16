# Python Notes

## Install
```
sudo apt-get install python3
## or
sudo apt install python3.x
python3 -V

## optional
sudo apt-get install python-is-python3
sudo apt-get install python3-doc
```

### Install pip
```
mkdir -pv "${HOME}/.config/pip/"
cat << EOF >${HOME}/.config/pip/pip.conf
[global]
cert = /etc/ssl/certs/ca-certificates.crt
trusted-host = pypi.python.org
               pypi.org
               files.pythonhosted.org
EOF

sudo apt-get -y install python3-pip
pip install --upgrade pip
```

## pip
```
pip list
pip install 'urllib3<2'
pip install -r requirements.txt
pip install numpy config --global http.sslVerify false
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org --upgrade setuptools
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org --upgrade pipwin
```

## venv
```
sudo apt install python3.8-venv
sudo apt install python3.12-venv
cd $HOME/dev
python3 -m venv (/path/to/new/)virtualenvironment
source (/path/to/new/)virtualenvironment/bin/activate
echo $VIRTUAL_ENV
...
pip install -r requirements.txt
...
deactivate
```

## Execute
```
export PYTHONPATH="${PYTHONPATH}:~/dev/python-libs/"
```
