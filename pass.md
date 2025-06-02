# pass

## gpg
```
gpg --generate-key
gpg --list-secret-keys
gpg --list-keys
gpg --export -a philipp@example.at [<id>] >/tmp/public.key
gpg --import /tmp/public.key # prints key name
gpg --edit-key <key-name>
```

## pass init
```
pass init -p org philipp@org.com
pass init -p example philipp@example.at

pwd # /home/user/.password-store
mv -v .gpg-id org/.gpg-id.bkp # backup
mv -v suboe.org.com.gpg org/

pass init -p org $(cat org/.gpg-id) # re-encrypt
```

## pass generate and edit
```
pass generate example/entry1 [n(password-length)]
pass edit example/entry1

~$ ls -lah .password-store/example/
total 16K
drwx------ 2 user user 4.0K May 16 17:31 .
drwx------ 5 user user 4.0K May 16 17:13 ..
-rw------- 1 user user   20 May 16 17:08 .gpg-id
-rw------- 1 user user  513 May 16 17:34 entry1.gpg
```

## pass insert
```
pass insert example/entry1
[Enter password for example/entry1:] <philipp@example.at:pa$$w0rd>
pass insert -m|--multiline example/multiline-entry
<password>
URL: https://subdomain.tld.com/
Username: xyz
Secret Question 1: What is your name?
```

## pass
```
pwd # ~/.password-store
pass # prints hierarchical view of password store
pass org/suboe.org.com/entry1 # retrieve password
pass -c|--clip org/suboe.org.com/entry1 # retrieve password via Xorg xclip or wl-clipboard
```

## pass show
```
pass show org/suboe.org.com
pass show example/entry1
```

## pass rm
```
pass rm example/entry1
```

## pass git
```
pass git <command>
pass git status
pass git log
pass git remote -v
pass git push
```

## pass restart
```
gpgconf --kill gpg-agent
exec bash/zsh
```
