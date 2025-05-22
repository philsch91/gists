# X Desktop Group (XDG)

```
env | grep -i xdg
sudo update-alternatives --config x-www-browser
```

## xdg-open
```
which xdg-open
xdg-open https://www.example.com
```

## xdg-open and wslview
```
## install wslview as part of the wslu package
sudo apt update
sudo apt install wslu
which wslview

## configure xdg-open to use wslview
mkdir -pv ~/.local/bin
echo '#!/bin/bash\nwslview "$1"' > ~/.local/bin/xdg-open
chmod +x ~/.local/bin/xdg-open
```
