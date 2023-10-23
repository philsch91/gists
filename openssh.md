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
# adds public key (id_rsa.pub) in /home/<username>/.ssh/authorized_keys
ssh-copy-id -i .ssh/id_rsa.pub <username>@<hostname-or-ip-address>
```
