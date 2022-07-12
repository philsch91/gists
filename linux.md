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
```

## systemd

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
