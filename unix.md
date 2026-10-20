# Unix

## Files

- /usr/local/sbin # takes precedence over /usr/sbin
- /usr/sbin # macOS SIP
- /usr/local/bin # executables in /usr/local/bin/ take precedence over /usr/bin/
- /usr/bin # macOS SIP
- ~/.local/bin
- ~/.local/share/<app>

## Shell

```
# default shell
echo $SHELL
# current shell
ps -o comm= $$
type -a <name>
command -v|-V <name>
# search PATH for executable files matching the given filename
which <filename>
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
