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

## Softwareupdate

```
sudo softwareupdate --reset-ignored
sudo softwareupdate --ignore "macOS Catalina"
sudo softwareupdate --ignore "macOS Big Sur"
# Remove system preferences badge
defaults write com.apple.systempreferences AttentionPrefBundleIDs 0
# Remove update badge
defaults delete com.apple.preferences.softwareupdate LatestMajorOSSeenByUserBundleIdentifier
# Get list of software updates
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
