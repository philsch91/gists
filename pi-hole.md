# Pi-hole

## Pi-hole Web
http://phils-pi5/admin/

## lighttpd
- `/etc/lighttpd/lighttpd.conf`

## pihole
```
/usr/local/bin/pihole version
pihole status
pihole enable
pihole -up|updatePihole
pihole -g|updateGravity
```

## systemctl
```
systemctl status pihole-FTL.service
systemctl status lighttpd.service
```

## netstat
```
netstat -anp | grep -i hole
netstat -anp | grep -i lighttpd
```

## ps
```
ps -ef | grep -i hole
```
