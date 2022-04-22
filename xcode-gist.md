# Xcode gist

## Support new devices with old Xcode

```
sudo ln -s /Applications/Xcode-13.2.1.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport/14.5 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport
```

## Add sym link from new to old iOS DeviceSupport

```
sudo ln -sv /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport/14.5 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport/14.7
```

## Unable to copy symbols from this device

```
rm -rf /Users/<username>/Library/Developer/Xcode/iOS\ DeviceSupport
```

## ShowBuildOperationDuration

```
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool "true"
defaults read com.apple.dt.Xcode ShowBuildOperationDuration
```
