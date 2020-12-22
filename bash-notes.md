# Bash Notes

### Parameter Substitution
${var+alt_value}
If var is set, use alt_value, else use null string.
${var:+alt_value}
If var is set and not null, use alt_value, else use null string
```
echo "${no_proxyy}${no_proxyy:+,}new-domain.tld"
new-domain.tld
echo "${no_proxy}${no_proxy:+,}new-domain.tld"
domain1,domain2,domain3,domain4,new-domain.tld
```

### Misc 
used to prevent filling up disk space in the CISL container
```
while((1)); do echo "$(date)">/tmp/db2logfile.log; sleep 60; done &
```