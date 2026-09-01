# Shell

Documentation, Notes and Snippets for Shell

## functions
```
# option 1
set_default_gitconfig() {
  arg1=$1
  local arg2=$2

  return
}

# option 2
function set_default_gitconfig() {
  arg1=$1
  local arg2=$2

  return
}
```

## declare (bash)
```
declare -r (=read-only) -x (=export) <variable-name>=<value> # declare read-only exported variable
sudo gdb -ex 'call unbind_variable("<variable-name>")' --pid=$$ --batch # unset read-only variable
```

## typeset (zsh)
```
typeset -r (=read-only) -x (=export) <variable-name>=<value> # set read-only exported variable
typeset +r <variable-name> # set read-only variable as read-write
unset <variable-name>
```

## test
```
# one-liner
if [ -d $XDG_CONFIG_HOME ]; then echo "$XDG_CONFIG_HOME exists and is a directory"; else echo "$XDG_CONFIG_HOME directory does not exist"; fi

# shorthand
## combines logical operators
[ -d $XDG_CONFIG_HOME ] && echo "$XDG_CONFIG_HOME exists and is a directory" || echo "$XDG_CONFIG_HOME directory does not exist"

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

### String operators
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

### File operators
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

## read
```
read -p "Enter your choice <y|n> " response
if [ $response = "Y" ] || [ $response = "y" ]; then
fi
```

## grep
```
# search for string in files
grep -rnwl '/path/to/directory' -e 'searchstring'
grep --include=\*.{c,h} -rnwl '/path/to/directory' -e 'searchstring'
grep --exclude=\*.o -rnwl '/path/to/directory' -e 'searchstring'
grep -ri -n|l [--include="*.txt *.php *.sh"] <search-string> .
<command> | grep -e 'term1' -e 'term2\|term3' [-A 10] [-B 10] # term1 or term2 or term3
```

## find
```
# Search for a directory
find / -type d -name "<dir-name>" 2>/dev/null

# Search for large files
find . -xdev -type f -printf "%s\t%p\n" | sort -n | tail -20

# Remove high number of files
find . -type f -print0 | xargs -0 rm -v
```

## Variable processing
```
lastchar="${var:$((${#var}-1)):1}"
if [ "$lastchar" != "/" ]; then
  var="${var}/"
fi
```

## Parameter expansion and substitution
```
# If var is set, use alt_value, else use null string.
${var+alt_value}

# If var is set and not null, use alt_value, else use null string
${var:+alt_value}
## example
DEBUG_MODE="true"
my_command ${DEBUG_MODE:+--verbose}

# If var is unset or empty, substitute nothing
${var:-}

echo "${no_proxyy}${no_proxyy:+,}new-domain.tld"
new-domain.tld
echo "${no_proxy}${no_proxy:+,}new-domain.tld"
domain1,domain2,domain3,domain4,new-domain.tld
```

## sed
```
# replace string in XML tag
LOGGINGCONFIGFILE="${CONFIG_PATH}/log4net.config"

if [ -n "${LOGLEVEL}" -a -f "${LOGGINGCONFIGFILE}" ]; then
    echo "Substitute default value with ${LOGLEVEL} in ${LOGGINGCONFIGFILE}"
    sed -i -E 's@(<level value=").*(" />)@\1'"$LOGLEVEL"'\2@' "${LOGGINGCONFIGFILE}"
fi
```

## while
```
# prevent filling up disk space in a container
while((1)); do echo "$(date)">/tmp/db2logfile.log; sleep 60; done &
```

## for
```
# response time measurement
for((i=0;i<=3600;i++)); do echo "$(date)" >>/tmp/readiness.log; time curl -k --noproxy "*" http://localhost:3769/readiness >>/tmp/readiness.log; sleep 1; done &
```

## bash
```
# exit if variables are unset
## use ${var:-} to guard for unset variables
set -o nounset (set -u)
# fail if any command in a pipeline (cmd1 | cmd2) fails
set -o pipefail
# -n = no execution (noexec) and syntax check, return code 0 = no errors
bash -n <file>.sh
echo $?

for file in *.sh; do bash -n "$file" || exit 1; done
```
