# fio flexible IO tester

## Windows
```
fio --randrepeat=1 --ioengine=windowsaio --direct=1 --gtod_reduce=1 --name=test1 --filename=D\:\fio\test1 --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75 --directory=D\:\fio --aux-path=D\:\fio --runtime=30 --time_based [--debug=io,file] 2>&1 | ForEach-Object ToString | Tee-Object -FilePath "C:\logs\fio.log" -Append
```
