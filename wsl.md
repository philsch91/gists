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
wsl --install --web-download -d <distribution-name> # --web-download = Download the update from the internet instead of the Microsoft Store.
wsl --status
wsl --version
wsl --update [--pre-release]
wsl -l|--list -o|--online
wsl -l|--list -v|--verbose
wsl --set-version <distribution-name> <version-number (1|2)>
wsl --set-default-version <1|2>
wsl -s|--set-default <distribution-name>
wsl --manage <distro-name> --move <new-location>
wsl --export <distribution-name> <file-name (.\dir\<distro-name>.tar)> [--vhd]
wsl --import <distribution-name> <install-location (.\newdir\<distro-name>)> <file-name (.\dir\<distro-name>.tar)> [--vhd] [--version <1|2>]
wsl -d <distribution-name> # run given distribution without changing the default distribution
wsl -d <distribution-name> -u <username|root> # run given distribution with given user name
passwd <username> # update password of account for the given user name
wsl --terminate <distribution-name>
wsl --shutdown
wsl --unregister <distribution-name> # all data, settings and software associated with the distribution will be uninstalled/deleted
wsl hostname -I
<distribution-name> config --default-user <username> (id -u <username>)
```

## Download and install WSL distribution
```
# Download with PS
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile ubuntu-2004.Appx -UseBasicParsing
# Download with curl
curl.exe -LR -o ubuntu-2004.Appx https://aka.ms/wslubuntu2204
# Install with Add-AppxPackage
```

### Install with Add-AppxPackage
```
Add-AppxPackage .\ubuntu-2004.Appx
```

### Install manually
```
# unpack .AppxBundle with MakeAppx.exe
& 'C:\Program Files (x86)\Windows Kits\10\App Certification Kit\makeappx.exe' unbundle /p .\ubuntu2404-240425.AppxBundle /d .\Ubuntu2404\

# unpack .appx with MakeAppx.exe
& 'C:\Program Files (x86)\Windows Kits\10\App Certification Kit\makeappx.exe' unpack /p .\Ubuntu2404\Ubuntu_2404.0.5.0_x64.appx /d .\Ubuntu2404-x64
# unpack .appx with Expand-Archive
Expand-Archive -LiteralPath .\Ubuntu2404\Ubuntu_2404.0.5.0_x64.appx -DestinationPath .\Ubuntu2404-x64

cp -rv Ubuntu2404-x64/install.tar.gz /mnt/c/Users/<username>/AppData/Local/WSL/images
mv -v /mnt/c/Users/<username>/AppData/Local/WSL/images/install.tar.gz /mnt/c/Users/<username>/AppData/Local/WSL/images/ubuntu-2404.tar.gz

# tar -xzvf /mnt/c/Users/<username>/AppData/Local/WSL/images/ubuntu-2404.tar.gz
command gunzip -c /mnt/c/Users/<username>/AppData/Local/WSL/images/ubuntu-2404.tar.gz >/mnt/c/Users/<username>/AppData/Local/WSL/images/ubuntu-2404.tar

wsl --import Ubuntu-24.04 C:\Users\<username>\AppData\Local\WSL\instances\Ubuntu-2404 C:\Users\<username>\AppData\Local\WSL\images\ubuntu-2404.tar --version 2

wsl -d Ubuntu-24.04 -u root useradd -m|--create-home -U|--user-group -d|--home-dir /home/<username> -G|--groups adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev -p|--password $(echo "<password>" | openssl passwd -1 -stdin) <username>
cat /etc/passwd | grep <username>
wsl --terminate Ubuntu-24.04

wsl -d Ubuntu-24.04
whoami
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

## wslg
```
ls -lah /mnt/wslg
cat /mnt/wslg/versions.txt
cat /mnt/wslg/weston.log
```

## Notes

If all interfaces are down according to `ifconfig -a` or `ip link`, uncompress recursively all files and folders in `%TEMP%`.

1. Terminate all WSL instances via `wsl --terminate <distro-name>` or shut down WSL via `wsl --shutdown`
2. Start `cmd.exe`
3. `cd %TEMP%` where %TEMP% = C:\Users\<username>\AppData\Local\Temp>
4. `compact /U /S [/I]`

Disable automatic NTFS compression
1. `fsutil behavior set disablecompression 1`

If there are problems with Docker on Windows.

1. Restart `Docker Desktop Service (com.docker.service)` at `C:\Program Files\Docker\Docker\com.docker.service` registered via `services.msc` and returned by `Get-Service -Name "Docker Desktop Service"`
2. Restart `C:\Program Files\Docker\Docker\Docker Desktop.exe` registered for Autostart via `msconfig`
