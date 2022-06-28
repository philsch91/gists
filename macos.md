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
