# Windows Subsystem for Linux (WSL)

WSL Windows Feature Installation Dir: `C:\Windows\System32\lxss`<br />
WSL Kernel Installation Dir: `C:\Windows\System32\lxss\tools`<br />
WSL Distribution Default Installation Dir: `%USERPROFILE%\AppData\Local\Packages\<PackageName>`<br />

## WSL in Registry
- `HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss`

## wsl
```
wsl --install [-d <distribution-name>]
wsl --status
wsl --version
wsl --update [--pre-release]
wsl -l|--list -o|--online
wsl -l|--list -v|--verbose
wsl --set-version <distribution-name> <version-number (1|2)>
wsl --set-default-version <1|2>
wsl --set-default <distribution-name>
wsl --manage <distro-name> --move <new-location>
wsl --export <distribution-name> <file-name (.\dir\<distro-name>.tar)> [--vhd]
wsl --import <distribution-name> <install-location (.\newdir\<distro-name>)> <file-name (.\dir\<distro-name>.tar)> [--vhd] [--version <1|2>]
wsl --terminate <distribution-name>
wsl --shutdown
wsl hostname -I
```

## apt
```
sudo apt-get update
sudo apt install wsl
wsl -v
which wsl
```

## free
```
# drop cache
free # shows buff/cache section
echo 3 | sudo tee /proc/sys/vm/drop_caches
```
