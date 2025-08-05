# Google Chrome

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
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install
which google-chrome
which google-chrome-stable
google-chrome [--profile-directory=Default]
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
sudo apt install -y p11-kit p11-kit-modules
ls /usr/lib/x86_64-linux-gnu/pkcs11
```

```
sudo mv -v /usr/lib/x86_64-linux-gnu/nss/libnssckbi.so /usr/lib/x86_64-linux-gnu/nss/libnssckbi.so.bkp
sudo ln -sv -f /usr/lib/x86_64-linux-gnu/pkcs11/p11-kit-trust.so /usr/lib/x86_64-linux-gnu/nss/libnssckbi.so
```

### p11-kit Firefox
```
sudo mv -v /usr/lib/firefox/libnssckbi.so /usr/lib/firefox/libnssckbi.so.bkp
sudo ln -sv -f /usr/lib/x86_64-linux-gnu/pkcs11/p11-kit-trust.so /usr/lib/firefox/libnssckbi.so
```
