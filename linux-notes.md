# Linux Notes

## Shell

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
