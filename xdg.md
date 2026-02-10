# X Desktop Group (XDG)

```
env | grep -i xdg
sudo update-alternatives --config x-www-browser
```

## xdg-open
```
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
