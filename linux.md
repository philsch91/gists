# Linux

## Shell

Default shell
```
echo $SHELL
```
Current shell
```
ps -o comm= $$
```

### Redirections

Redirect both STDOUT and STDERR to /dev/null.
Redirect STDERR to STDOUT and STDOUT to /dev/null.
```
command >/dev/null 2>&1
```

Redirect only STDOUT to /dev/null, while STDERR is redirected to STDOUT, which is redirected to /dev/null
```
command 2>&1 >/dev/null
```

## ln
```
# symlink (soft link)
ln -s <destination-dir> <source-dir>
```

## find

```
# find and ignore permission denied errors
find / -name "filename*" 2>/dev/null
# recursively find all files in cwd and call dos2unix for them
find . -type f -print0 | xargs -0 dos2unix
# recursively find all files in cwd containing the given regular expression
find . -type f -print0 | xargs -0 grep <regex>
```

## sed

```
grep -rl [-I] <old-string> . [--exclude-dir=.git] | xargs sed -i 's/<old-string>/<new-string>/g'
```

## SysV

```
ls -lah /etc/init.d/
ls -lah /etc/rc*
// update-rc.d
update-rc.d <service> disable
update-rc.d apache2 disable
// or via chkconfig
sudo apt-get install chkconfig
chkconfig <service> off|on
chkconfig --add <service>
// or via sysv-rc-conf
sudo apt-get install sysv-rc-conf
// or via rcconf
sudo apt-get install rcconf
```

## systemd

### Start and stop services
```
systemctl status <service>
systemctl start <service>
systemctl stop <service>
```

### List unit files
```
systemctl list-unit-files --type=service --state=enabled,running,generated
systemctl list-unit-files | grep -i enabled
systemctl list-unit-files | grep -i running
```

### List units

systemd services in `state=active` and `sub=running`
```
systemctl list-units --type=service --state=running
```
systemd services in `state=active` and `sub` either `running` or `exited`
```
systemctl list-units --type=service --state=active
```

### Enable and disable services
```
systemctl enable <service>
systemctl disable <service>
```

## netcat

Check network connectivity
```
nc -zv <host> <port>
```

Start network listening
```
nc -lk <port>
```

## ldapsearch
```
ldapsearch -x -H ldaps://<ldap-host>:636 -D "CN=TU001,OU=Service_Accounts,OU=Accounts,DC=domain,DC=rootdom,DC=net" -w '<password>' -b "DC=rootdom,DC=net" "cn=<user-id>" dn
```

## getent
```
getent hosts <hostname>
```
