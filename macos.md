# macOS

## Paths

- /usr/local/sbin
- /usr/sbin
- /usr/local/bin
- /usr/bin
- executables in /usr/local/bin/ take precedence over /usr/bin/
- ~/.local/bin
- ~/.local/share/<app>

### `/Users/<username>`
```
# /Users/<username>/.vscode
find /Users/<username> -type d -iname ".*" 2>/dev/null | grep -i vscode
```

### `~/Library`
```
find /Users/<username>/Library/ -type d -iname "Visual Studio" 2>/dev/null
find /Users/<username>/Library/ -type f -iname "Visual Studio" 2>/dev/null

find /Users/<username>/Library/ -type d -iname "VisualStudio" 2>/dev/null
find /Users/<username>/Library/ -type f -iname "VisualStudio" 2>/dev/null

find /Users/<username>/Library/ -type d -iname "Xamarin" 2>/dev/null
find /Users/<username>/Library/ -type f -iname "Xamarin" 2>/dev/null

# /Users/<username>/Library/Application Support/Code
find /Users/<username>/Library/ -type d -iname "code" 2>/dev/null
find /Users/<username>/Library/ -type f -iname "code" 2>/dev/null
```

## nvram

```
# To prevent startup when opening the lid or connecting to power
sudo nvram BootPreference=%00
# To prevent startup only when opening the lid
sudo nvram BootPreference=%01
# To prevent startup only when connecting to power
sudo nvram BootPreference=%02
# Reenable automatic startup when opening the lid or connecting to power
sudo nvram -d BootPreference
```

## scutil
```
scutil --get ComputerName
scutil --get LocalHostName
scutil --get HostName
scutil --set ComputerName "<computer-name>"
scutil --set LocalHostName "<local-hostname>"
scutil --set HostName "<hostname>"
```

## chpass (chsh, chfn)
```
# read and display list of built-in shell paths
cat /etc/shells
# change user shell
chsh -s /bin/zsh | /bin/bash
```

## sudo

- /private/etc/sudoers
- /private/etc/sudoers.d/

```
sudo zsh -c 'echo "<username> ALL=(ALL) NOPASSWD: /usr/bin/pmset" > /private/etc/sudoers.d/10-pmset'
```

## BSD Programs and Commands

Get file encoding
```
file -I <file-name>
```

Character set conversion
```
iconv -f UTF-16LE -t UTF-8 <file-name> > <file-name-new>
```

Remove Byte Order Mark (BOM)
```
vim -c "set nobomb" -c wq! <file-name>
```

## SIPS
```
# Resample image so height and width aren't greater than specified size.
sips <input-filename> -Z <pixels-height-width-max> --out <output-filename>
# Resample image at specified size. Image apsect ratio may be altered.
sips <input-filename> -z <pixels-height> <pixels-width> --out <output-filename>
```

## strings
```
strings /path/to/file.pdf | grep -i FontName
```

## pkgutil
```
# List all installed packages
# TODO: Check if an executed .app file installs itself as package
pkgutil --pkgs

# Show package info
# date -r <install-unix-timestamp>
pkgutil --pkg-info <package-name>

# List files for package
pkgutil --files <package-name>

# List only files (not directories) in --files listing for package
pkgutil --only-files --files <package-name>

# List files for package and delete them
pkgutil --only-files --files <package-name> | tr '\n' '\0' | xargs -n 1 -0 -p sudo rm [-if]

# List only directories (not files) in --files listing for package
pkgutil --only-dirs --files <package-name>

# List directories for package and delete them
pkgutil --only-dirs --files <package-name> | tr '\n' '\0' | xargs -n 1 -0 -p sudo rmdir

# Remove package receipt (after removing the files)
pkgutil --forget <package-name>

# Unlink package (not documented)
pkgutil --unlink <package-name>
```

## launchctl
```
launchctl list
launchctl print system
launchctl print gui/<user-id>
launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist
launchctl load -w /System/Library/LaunchDaemons/ssh.plist
launchctl unload -w /Library/LaunchAgents/com.adobe.AdobeCreativeCloud.plist
// new syntax
launchctl bootstrap gui/<user-id> /System/Library/LaunchDaemons/ssh.plist
launchctl bootout gui/<user-id> /System/Library/LaunchDaemons/ssh.plist
```

### launchctl .plist locations
- /Library/LaunchDaemons/
System wide daemons provided by the admin
- /Library/LaunchAgents/
User daemons provided by the admin
- ~/Library/LaunchAgents/
User daemons provided by the user
- /System/Library/LaunchDaemons/
macOS system daemons
- /System/Library/LaunchAgents/
macOS user daemons

## pmset
```
# -b=battery, -c=charger, -u=ups, -a=all (battery + charger + ups)
# display settings in use
pmset -g

# set 0 minutes before (disable) sleep
pmset [-b|-a] sleep 0
# set 5 minutes before (re-enable) sleep
pmset [-b|-a] sleep 5

# pmset sleep not needed for pmset disablesleep
# disable sleep, also when the lid is closed
pmset [-b|-a] disablesleep 1
# re-enable sleep
pmset [-b|-a] disablesleep 0

# reduce disk sleep time to x minute(s)
pmset -a disksleep x
```

## caffeinate
```
# create assertion to prevent display sleep and screen saver
caffeinate -d -t 3600
# create assertion to declare active user (prevent system idle sleep) and to prevent display idle sleep
# If timeout is not specified with '-t x', the assertion is created with default timeout of 5 seconds
caffeinate -u -t 3600
```

## Softwareupdate

```
sudo softwareupdate --reset-ignored
sudo softwareupdate --ignore "macOS Catalina"
sudo softwareupdate --ignore "macOS Big Sur"
# Read local updates
defaults read ~/Library/Preferences/com.apple.preferences.softwareupdate.plist
# Remove system preferences badge
defaults write com.apple.systempreferences AttentionPrefBundleIDs 0
# Clear updates and remove update badge
defaults delete com.apple.preferences.softwareupdate LatestMajorOSSeenByUserBundleIdentifier
# Refresh and get list of software updates
softwareupdate --list
# Advanced
# Attention: change files from another disk, otherwise system will be read-only
mv /System/Library/LaunchAgents/com.apple.SoftwareUpdateNotificationManager.plist /System/Library/LaunchAgentsIgnored/com.apple.SoftwareUpdateNotificationManager.plist
# Change notification configuration
/System/Library/UserNotifications/Bundles/com.apple.SoftwareUpdateNotification.bundle/Contents/Info.plist
```

## Finder

```
defaults write com.apple.finder CreateDesktop 0
```

## powermetrics

```
sudo powermetrics --samplers cpu_power,smc -i1000 -n1 | egrep -i 'power|CPU die temperature'
```

## hdiutil

```
hdiutil info
hdiutil create -size <1234>g -type <image-type> -fs <fs-type> -volname <volume-name> <file>
hdiutil imageinfo <file>
# attach
## ls /Volumes
## attach -nomount -readonly
hdiutil attach -noverify -nomount -readonly /Volumes/<volume-name>/<file-name>.sparsebundle
## attach -readonly -shadow
hdiutil attach -noverify -readonly -verbose -shadow /tmp/tm-backup.shadow | ~/Desktop/tm-backup.shadow /Volumes/<volume-name>/<file-name>.sparsebundle
## attach -nomount -readwrite -noautofsck = no filesystem check
hdiutil attach -noverify -nomount -readwrite -noautofsck /Volumes/<volume-name>/<file-name>.sparsebundle
```

## fsck_hfs
```
## /dev/rdisk4s2 from `hdiutil attach` or `hdiutil info`
# -d=debug
fsck_hfs -d -f -y /dev/rdisk4s2
```

## diskutil
```
## /dev/disk4s2 from `hdiutil attach` or `hdiutil info`
diskutil mount readOnly /dev/disk4s2
```

## mount
```
## /dev/disk4s2 from `hdiutil attach` or `hdiutil info`
sudo mkdir [-v] /Volumes/TimeMachineForce
sudo mount -t hfs -o rdonly /dev/disk4s2 /Volumes/TimeMachineForce
```

## Time Machine tmutil

```
tmutil destinationinfo
tmutil startbackup [-b(=foreground)]
tmutil stopbackup
tmutil disablelocal
tmutil enablelocal
tmutil enable # enable automatic backups
tmutil disable # disable automatic backups
tmutil addexclusion -p ~/Downloads
tmutil setdestination /Volume/<volume-name>
tmutil setdestination [-a(=append)] "<protocol://user[:password]@host/share>"
tmutil removedestination
tmutil listbackups
tmutil delete /Volumes/<volume-name>/path/to/*.backupdb/<device-name>/<year>
tmutil delete /Volumes/<volume-name>/Backups.backupdb/<backup-file>
```

### Time Machine via SMB

1. `hdiutil create -size 600g -type SPARSEBUNDLE -fs "HFS+J" -volname TimeMachine TimeMachine.sparsebundle`
1. copy TimeMachine.sparsebundle to SMB share
1. mount the sparse image on the share as volume with a double click
1. `sudo tmutil setdestination /Volumes/TimeMachine`

## apachectl
```
apachectl [start|stop|restart|graceful|status|fullstatus|configtest]
```
