# Bash Notes

### Search for string in files
```
grep -rnwl '/path/to/directory' -e 'searchstring'
grep --include=\*.{c,h} -rnwl '/path/to/directory' -e 'searchstring'
grep --exclude=\*.o -rnwl '/path/to/directory' -e 'searchstring'
```

### Parameter Substitution
${var+alt_value}
If var is set, use alt_value, else use null string.<br />
${var:+alt_value}
If var is set and not null, use alt_value, else use null string
```
echo "${no_proxyy}${no_proxyy:+,}new-domain.tld"
new-domain.tld
echo "${no_proxy}${no_proxy:+,}new-domain.tld"
domain1,domain2,domain3,domain4,new-domain.tld
```

### Replace String in XML tag
```
LOGGINGCONFIGFILE="${CONFIG_PATH}/log4net.config"

if [ -n "${LOGLEVEL}" -a -f "${LOGGINGCONFIGFILE}" ]; then
    echo "Substitute default value with ${LOGLEVEL} in ${LOGGINGCONFIGFILE}"
    sed -i -E 's@(<level value=").*(" />)@\1'"$LOGLEVEL"'\2@' "${LOGGINGCONFIGFILE}"
fi
```

### Misc 
used to prevent filling up disk space in the CISL container
```
while((1)); do echo "$(date)">/tmp/db2logfile.log; sleep 60; done &
```