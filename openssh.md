# openssh

## ssh-keygen
```
# default is ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub
ssh-keygen -t rsa
```

## ssh-copy-id
```
chmod 700 /home/<username>/.ssh && chmod 600 /home/<username>/.ssh/authorized_keys
chown -R <username>:<username> /home/<username>/.ssh
# adds public key (id_rsa.pub) in /home/<username>/.ssh/authorized_keys on remote system
ssh-copy-id -i .ssh/id_rsa.pub <username>@<hostname-or-ip-address>
```

## sshpass
```
sshpass -p <password> ssh-copy-id [-i <identity-file-name>] [<username>@]<hostname-or-ip-address>
sshpass -f <password-file-name> ssh-copy-id [-i <identity-file-name>] [<username>@]<hostname-or-ip-address>
```

## ssh
```
ssh [-i <identity-file-name>[~/.ssh/id_rsa]] [<username>@]<hostname-or-ip-address> -p <port>
```
