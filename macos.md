# macOS

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

## powermetrics

```
sudo powermetrics --samplers cpu_power,smc -i1000 -n1 | egrep -i 'power|CPU die temperature'
```

## Time Machine

### Time Machine via SMB

1. `hdiutil create -size 600g -type SPARSEBUNDLE -fs "HFS+J" -volname TimeMachine TimeMachine.sparsebundle`
1. copy TimeMachine.sparsebundle to SMB share
1. mount the sparse image on the share as volume with a double click
1. `sudo tmutil setdestination /Volumes/TimeMachine`

## apachectl
```
apachectl [start|stop|restart|graceful|status|fullstatus|configtest]
```
