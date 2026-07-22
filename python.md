# Python

## Variables
```
# global Python, Python standard module 'ssl', and OpenSSL
SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
# Python module 'requests'
# requests library uses certifi package with separate certificates
REQUESTS_CA_BUNDLE="/etc/ssl/certs/ca-bundle.crt"
# Python module 'curl'
CURL_CA_BUNDLE="/etc/ssl/certs/ca-bundle.crt"
PYTHONHTTPSVERIFY=0
# disable creation of Python byte code files
PYTHONDONTWRITEBYTECODE=1
```

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
pip --version
pip list
pip install 'urllib3<2'
pip install [--no-cache-dir] -r requirements.txt
pip install numpy config --global http.sslVerify false
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org --upgrade setuptools
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org --upgrade pipwin

python -m pip --version
python -m pip list
```

## venv
```
sudo apt install python3.8-venv
sudo apt install python3.12-venv
cd $HOME/dev
python3 -m venv (/path/to/new/)virtualenvironment
source (/path/to/new/)virtualenvironment/bin/activate
echo $VIRTUAL_ENV
which python
# install pip in virtual environment without affecting system (OS) Python
python -m ensurepip --default-pip
...
# option 1
pip install -r requirements.txt
pip list
# option 2
python -m pip install -r requirements.txt
python -m pip list
...
deactivate
```

### venv pyvenv.cfg
```
# Linux
home = /usr/bin
include-system-site-packages = false
version = 3.12.3
executable = /usr/bin/python3.12
command = /usr/bin/python3 -m venv /mnt/c/dev/python-venv-linux
# Windows
home = c:\python313
include-system-site-packages = false
version = 3.13.5
executable = C:\Python313\python.exe
command = c:\python313\python.exe -m venv C:\dev\python-venv-windows
```

## Execute
```
export PYTHONPATH="${PYTHONPATH}:~/dev/python-libs/"
python -c "import sys; print('Success!')"

# certifi
## curl uses a fallback mechanism from CAfile (--cacert) to CApath (--capath)
/usr/bin/python3.12 -c "import certifi; print(certifi.where())"
curl -v https://<hostname> --cacert $(/usr/bin/python3.12 -c "import certifi; print(certifi.where())")

echo "https://hostname.subdomain.tld" | /usr/bin/python3.12 -c "import sys, os, requests; url = sys.stdin.read().strip(); req_ca_bundle_var = os.environ.get('REQUESTS_CA_BUNDLE'); print(f'REQUESTS_CA_BUNDLE: {req_ca_bundle_var}'); os.environ.pop('REQUESTS_CA_BUNDLE', None); req_ca_bundle_var = os.environ.get('REQUESTS_CA_BUNDLE'); print(f'REQUESTS_CA_BUNDLE: {req_ca_bundle_var}'); response = requests.post(url, verify=True); print(f'Status: {response.status_code}'); print(response.text)"

/usr/bin/env /mnt/c/dev/python-venv-linux/bin/python - << 'PY'
import importlib, traceback, sys
try:
    importlib.import_module('llm.openai')
    importlib.import_module('workflows.nodes')
    print('IMPORT_OK')
except Exception:
    traceback.print_exc()
    sys.exit(1)
PY
```

## pyproject.toml
```
[build-system]
requires = ["setuptools>=64"]
build-backend = "setuptools.build_meta"

[project]
name = "program"
version = "1.0.0"
requires-python = ">=3.11"
dependencies = [
    "httpx>=0.27",
    "pydantic>=2.0",
    "python-dotenv>=1.0",
    "click>=8.0",
    "mcp>=1.0.0",
    "cryptography>=42.0",
]

[tool.setuptools.packages.find]
where = ["src"]

[tool.mypy]
strict = true
packages = ["program"]
mypy_path = "src"

[project.scripts]
program = "<package>.<file>:<function>"
```

## click

### program auth login
```
@click.group()
def cli() -> None:
    """Program: Program description."""

@cli.group()
def auth() -> None:
    """Manage authentication."""

@auth.command("login")
def auth_login() -> None:
	"""Authentication login."""
```

## Errors

### error: externally-managed-environment
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
