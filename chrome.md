# Google Chrome

## Files
```
ls -lah /opt/google/chrome/
ls -lah /home/<username>/.config/google-chrome/
```

## Sessions and Tabs
```
C:\Users\<username>\AppData\Local\Google\Chrome\User Data\Default\Sessions
ls $HOME/.config/google-chrome/Default/Sessions
```

- Session_* files are written when Chrome is properly closed (chrome://quit) and started, a window is closed, a tab is closed and opened and selected, a new URL is opened, and regularly
- Tabs_* files are written when Chrome is properly closed (chrome://quit) and started, a window is closed, and sometimes a tab is closed and opened

## Installation
```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome-stable_current_amd64.deb
## dpkg -i = only local without download of dependencies
# sudo dpkg -i google-chrome-stable_current_amd64.deb
## apt install creates /etc/apt/sources.list.d/google-chrome.sources
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install # optional

cat /etc/apt/sources.list.d/google-chrome.sources
### THIS FILE IS AUTOMATICALLY CONFIGURED ###
# Changes to this file will not be preserved.
# This file will not be recreated if removed.
X-Repolib-Name: Google Chrome
Types: deb
URIs: https://dl.google.com/linux/chrome-stable/deb/
Suites: stable
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/google-chrome.gpg

apt list --installed "*chrome*"
which google-chrome
which google-chrome-stable

cp -rv $HOME/.config/google-chrome/Default/Sessions $HOME/.config/google-chrome/Default/Sessions-backup
mkdir -pv /mnt/wsl/share/google-chrome/Default
cp -rv $HOME/.config/google-chrome/Default/Sessions-backup /mnt/wsl/share/google-chrome/Default/

google-chrome [--profile-directory=Default] [--no-sandbox] [--disable-gpu] [--disable-software-rasterizer] [--disable-accelerated-video-decode] [--disable-machine-cert-request-policy] [&]

ps -ef | grep google-chrome
```

```
sudo touch /etc/default/google-chrome
ls -lh /etc/default/google-chrome
cat /etc/default/google-chrome
repo_add_once="false"
repo_reenable_on_distupgrade="true"
```

## libnss
```
ls /usr/lib/x86_64-linux-gnu/nss
ls /usr/lib/x86_64-linux-gnu/nss/libnssckbi.so
```

### libnss Firefox
```
ls /usr/lib/firefox
ls /usr/lib/firefox/libnssckbi.so
```

## p11-kit
```
apt list --installed "p11-kit*"
sudo apt install -y p11-kit p11-kit-modules
ls /usr/lib/x86_64-linux-gnu/pkcs11

# Ubuntu-20.04
sudo mv -v /usr/lib/x86_64-linux-gnu/nss/libnssckbi.so /usr/lib/x86_64-linux-gnu/nss/libnssckbi.so.bkp
# Ubuntu-24.04
apt list --installed "libnss3-tools*"
sudo apt install libnss3-tools
sudo mkdir -pv /usr/lib/x86_64-linux-gnu/nss
sudo ln -sv -f /usr/lib/x86_64-linux-gnu/pkcs11/p11-kit-trust.so /usr/lib/x86_64-linux-gnu/nss/libnssckbi.so
# $HOME/.pki/nssdb/libnssckbi.so
mkdir -pv $HOME/.pki/nssdb
ln -sv -f /usr/lib/x86_64-linux-gnu/pkcs11/p11-kit-trust.so $HOME/.pki/nssdb/libnssckbi.so
```

### p11-kit Firefox
```
sudo mv -v /usr/lib/firefox/libnssckbi.so /usr/lib/firefox/libnssckbi.so.bkp
sudo ln -sv -f /usr/lib/x86_64-linux-gnu/pkcs11/p11-kit-trust.so /usr/lib/firefox/libnssckbi.so
```
