# pass

## pass init
```
pass init -p org philipp@org.com
pass init -p example philipp@example.at

pwd # /home/user/.password-store
mv -v .gpg-id org/.gpg-id.bkp # backup
mv -v suboe.org.com.gpg org/
```

## pass generate and edit
```
pass generate example/entry1
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
```

## pass rm
```
pass rm example/entry1
```

## pass show
```
pass show org/suboe.org.com
pass show example/entry1
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
