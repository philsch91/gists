# macOS Notes

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
