# Bash

Documentation, Notes and Snippets for Bash

## functions
```
# option 1
function set_default_gitconfig () {
  arg1=$1
  arg2=$2

  return
}
# option 2
set_default_gitconfig() {
  arg1=$1
  arg2=$2

  return
}
```

### test

```
if [ $# -ne 1 -a "$2" != "old" ]; then
  # number of arguments is not equal to 1 and argument 2 is not equal to "old"
fi

if [ ${STATUS} -eq 200 ] && [ "${STRING}" = "${VALUE}" ]; then
  # STATUS is 200 and STRING is equal to VALUE
fi

if [ ${STATUS} -ne 200 ] && [ "${STRING}" != "${VALUE}" ]; then
  # STATUS is not equal to 200 and STRING is not equal to VALUE
fi

STRING_VAR=abc-admin-assumerole
if [ -z ${STRING_VAR##*admin-assumerole} ]; then
  # STRING_VAR ends with substring admin-assumerole
  echo "YES"
else
  echo "NO"
fi

if [ ${STAGE_NAME} = "prod" ] || [ -z ${CLUSTER_NAME##*prod*} ] && [ ! -z ${CLUSTER_NAME##*nonprod*} ]; then
  # return early if STAGE_NAME is equal to "prod" or CLUSTER_NAME contains "prod" and CLUSTER_NAME does not contain "nonprod"
  exit 0
fi
```

#### String operators
```
if [ -n "${VAR}" ]; then
  # VAR is non-zero and not empty
fi

if [ -z "${VAR}" ]; then
  # VAR is zero and empty
fi

if [ ! -z "${VAR}" ]; then
  # VAR is not empty
fi
```

#### File operators
```
if [ -f "${FILE_PATH}" ]; then
  # file at FILE_PATH exists and is a regular file
fi

if [ -n "${VAR}" -a -f "${FILE}" ]; then
  # VAR is not empty and FILE exists as a regular file
fi

if [ ! -f "${HOME}/.git-credentials" ] || ! grep -q $GITCONFIG_NAME $HOME/.git-credentials ; then
  read -p "Git token: (https://github.com/settings/tokens): " GIT_TOKEN
  echo "https://${GITCONFIG_NAME}:${GIT_TOKEN}@github.com" >>${HOME}/.git-credentials
fi
```

### read
```
read -p "Enter your choice <y|n> " response
if [ $response = "Y" ] || [ $response = "y" ]; then
fi
```

### grep

#### Search for string in files
```
grep -rnwl '/path/to/directory' -e 'searchstring'
grep --include=\*.{c,h} -rnwl '/path/to/directory' -e 'searchstring'
grep --exclude=\*.o -rnwl '/path/to/directory' -e 'searchstring'
```

### find

#### Search for a directory
```
find / -type d -name "<dir-name>" 2>/dev/null
```
#### Search for large files
```
find . -xdev -type f -printf "%s\t%p\n" | sort -n | tail -20
```
#### Remove high number of files
```
find . -type f -print0 | xargs -0 rm -v
```

### Variable processing
```
lastchar="${var:$((${#var}-1)):1}"
if [ "$lastchar" != "/" ]; then
  var="${var}/"
fi
```

#### Parameter Substitution
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

#### Replace String in XML tag
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
response time measurement
```
for((i=0;i<=3600;i++)); do echo "$(date)" >>/tmp/readiness.log; time curl -k --noproxy "*" http://localhost:3769/readiness >>/tmp/readiness.log; sleep 1; done &
```
