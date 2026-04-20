# X Desktop Group (XDG)

## Environment variables
```
export XDG_CURRENT_DESKTOP=GNOME
env | grep -i XDG
XDG_CONFIG_HOME=/home/<username>/.config
XDG_CURRENT_DESKTOP=GNOME
XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
XDG_RUNTIME_DIR=/run/user/1001
XDG_DATA_DIRS=/usr/local/share/:/usr/share/:/var/lib/snapd/desktop
sudo update-alternatives --config x-www-browser
```

## xdg-open with xdg-utils
```
apt list --installed "xdg-utils"
apt install xdg-utils
which xdg-open # /usr/bin/xdg-open # = default
xdg-open https://www.example.com
```

## wslview
```
## install wslview as part of the wslu package
sudo apt update
sudo apt install wslu
which wslview

## xdg-open and wslview
### configure xdg-open to use wslview
### override /usr/bin/xdg-open with ~/.local/bin/xdg-open
mkdir -pv ~/.local/bin
echo -e '#!/bin/bash\nwslview "$1"' > ~/.local/bin/xdg-open
chmod +x ~/.local/bin/xdg-open
# export PATH="$PATH:${HOME}/.local/bin"
```
