# Windows

## User Accounts

Get user details
```
whoami
echo %USERNAME%
echo %USERDOMAIN%
Get-LocalUser -Name 'username' | Select-Object *
```

RDP login with Microsoft account if USERDOMAIN=AzureAD<br />
User account: AzureAD\<user@domain.tld>

## WSL

List running wsl processes
```
wsl -l -v
wsl --list --verbose
```

Shutdown or terminate
```
wsl --shutdown
wsl -t <distro-name>
```

Set wsl default version
```
wsl --set-default-version 2
```

Set wsl default distribution
```
wsl --set-default <wsl-name>
```

Set wsl version for process
```
wsl --set-version <wsl-name or wsl-pid> 2
```

DNS Config
```
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "[network]" > /etc/wsl.conf'
sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
sudo chattr +i /etc/resolv.conf
```

## ATA TRIM

### Query TRIM setting

- Enabled: DisableDeleteNotify=0
- Disabled: DisableDeleteNotify=1

```
fsutil behavior query DisableDeleteNotify
```

### Set TRIM setting

#### Enable TRIM
```
fsutil behavior set DisableDeleteNotify 0
```

#### Disable TRIM
```
fsutil behavior set DisableDeleteNotfiy 1
```

## Explorer
```
HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced
DWORD DisablePreviewWindow = 1

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"NoDrives"=dword:00000400

[HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell]
"FolderType"="NotSpecified"
```

## Search
```
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search]
"BingSearchEnabled"=dword:00000000
```

## Automatic Updates
```
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU
```

## Internet Settings
```
Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings
```

## Hiberboot
```
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power]
"HiberbootEnabled"=dword:00000000
```

## CredSSP
```
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP]

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters]
"AllowEncryptionOracle"=dword:00000002
```

## Docker
```
%localappdata%\Docker\log.txt
C:\Users\<user>\AppData\Local\Docker\log.txt
%appdata%\Docker\settings.json
C:\Users\<user>\AppData\Roaming\Docker\settings.json
C:\Users\<user>\.docker\config.json
```
