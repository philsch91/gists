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

which python3
/usr/bin/python3

ls -la /usr/bin/python3
/usr/bin/python3 -> python3.8

which python3.8
/usr/bin/python3.8

ls -la /usr/bin/python3.8
/usr/bin/python3.8

## optional 2
ln -s /usr/bin/python3.x /usr/bin/python3
ln -s /usr/bin/python3 /usr/bin/python
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
# invoke pip associated with the called Python version
python -m pip install --upgrade pip
# invoke pip executable
pip install --upgrade pip

## optional
ln -s /usr/bin/pip3 /usr/bin/pip
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

## Errors

error: externally-managed-environment
```
# option 1
<command (python -m pip install --upgrade pip)> --break-system-packages

# option 2
mkdir -pv "${HOME}/.config/pip/"
cat << EOF >${HOME}/.config/pip/pip.conf
[global]
break-system-packages = true
EOF

# option 3
python3 -m pip config set global.break-system-packages true

# option 4
sudo mv /usr/lib/python3.x/EXTERNALLY-MANAGED /usr/lib/python3.x/EXTERNALLY-MANAGED.old
```
