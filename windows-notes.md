# Windows Notes

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
wsl --list --verbose
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
```

## Automatic Updates
```
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU
```

## Internet Settings
```
Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings
```
