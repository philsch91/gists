# Python Notes

## pip
```
pip install numpy config --global http.sslVerify false
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org awsume
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org --upgrade setuptools
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org --upgrade pipwin
```
## venv
```
sudo apt install python3.8-venv
cd $HOME/dev
python3 -m venv /path/to/new/virtual/environment
source /path/to/new/virtual/environment/bin/activate
echo $VIRTUAL_ENV
deactivate
```
