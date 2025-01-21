# Windows Subsystem for Linux (WSL)

WSL Windows Feature Installation Dir: `C:\Windows\System32\lxss`<br />
WSL Kernel Installation Dir: `C:\Windows\System32\lxss\tools`<br />
WSL Distribution Default Installation Dir: `%USERPROFILE%\AppData\Local\Packages\<PackageName>`<br />

## WSL in Registry
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss`
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss\DefaultDistribution`
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss\DefaultVersion`
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss\{DistributionId}`
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss\{DistributionId}\DistributionName`
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss\{DistributionId}\BasePath`
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss\{DistributionId}\DefaultUid`

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
wsl -d <distribution-name> -u <username|root>
wsl --terminate <distribution-name>
wsl --shutdown
wsl hostname -I
<distribution-name> config --default-user <username> (id -u <username>)
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

## Notes

If all interfaces are down according to `ifconfig -a` or `ip link`, uncompress recursively all files and folders in `%TEMP%`.

1. Terminate all WSL instances via `wsl --terminate <distro-name>` or shut down WSL via `wsl --shutdown`
2. Start `cmd.exe`
3. `cd %TEMP%` where %TEMP% = C:\Users\<username>\AppData\Local\Temp>
4. `compact /U /S [/I]`

Disable automatic NTFS compression
1. `fsutil behavior set disablecompression 1`
