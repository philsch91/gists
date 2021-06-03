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
