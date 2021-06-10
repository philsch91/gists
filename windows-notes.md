# Windows Notes

## wsl

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
