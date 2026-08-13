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

## netsh
```
netsh mbn show interface
netsh mbn show radio interface="Mobilfunk"
Get-PnpDevice -Class Net | ForEach-Object { $id = $_.InstanceId; $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($id)\Device Parameters"; echo "RegPath: $($RegPath)"; Get-ItemProperty -Path $regPath -Name DeviceSelectiveSuspended -ErrorAction SilentlyContinue }
```

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

## Visual Studio
```
# vswhere.exe
C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe
vswhere.exe -property installationPath
vswhere.exe -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools -find "VC\Tools\MSVC\**\bin\Hostx64\x64\cl.exe"
vswhere.exe -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -find "VC\Tools\MSVC\**\bin\Hostx64\x64\cl.exe"
vswhere.exe -path "C:\Program Files\Microsoft Visual Studio\2022\Professional" -format json
# setup.exe
C:\Program Files(x86)\Microsoft Visual Studio\Installer\setup.exe
# --quiet = prevents UI from being displayed; for non-interactive installation via service, LocalSystem and session 0
# --passive = display non-interactive UI; for interactive desktop installation
# 1. modifySettings: switch to update channel
setup.exe modifySettings --installPath "C:\Program Files\Microsoft Visual Studio\2022\Professional" --newChannelUri https://aka.ms/vs/17/release/channel --passive
# check channelUri
vswhere.exe -path "C:\Program Files\Microsoft Visual Studio\2022\Professional" -format json
# 2. update: download and install new channel
setup.exe update --installPath "C:\Program Files\Microsoft Visual Studio\2022\Professional" --passive --norestart
# check installationVersion
vswhere.exe -path "C:\Program Files\Microsoft Visual Studio\2022\Professional" -format json
# 3. modify: re-assert component list
setup.exe modify --installPath "C:\Program Files\Microsoft Visual Studio\2022\Professional" --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Component.CoreEditor --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core --add Component.VisualStudio.GitHub.Copilot --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.ATL --add Microsoft.VisualStudio.Component.CppBuildInsights --add Microsoft.VisualStudio.Component.Debugger.JustInTime --add Microsoft.VisualStudio.Component.VC.DiagnosticTools --add Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.VC.TestAdapterForBoostTest --add Microsoft.VisualStudio.Component.VC.TestAdapterForGoogleTest --add Component.Microsoft.VisualStudio.LiveShare.2022 --add Microsoft.VisualStudio.Component.IntelliCode --add Microsoft.VisualStudio.Component.VC.ASAN --add Microsoft.VisualStudio.Component.Windows11SDK.22621 --add Microsoft.VisualStudio.Component.Vcpkg --add Microsoft.VisualStudio.Component.VC.ATLMFC --add Microsoft.VisualStudio.Component.VC.Modules.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --add Microsoft.Net.Component.4.8.1.SDK --add Microsoft.Net.Component.4.8.1.TargetingPack --passive --norestart
# cl.exe
C:\Program Files\Microsoft Visual Studio\2022\<edition>\VC\Tools\MSVC\<version>\bin\Hostx64\x64\cl.exe
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

```
REM classic (Win 10) context menu
REM restart explorer.exe
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
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
