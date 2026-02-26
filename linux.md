# Linux

## Paths

- /usr/local/sbin
- /usr/sbin
- /usr/local/bin
- /usr/bin
- executables in /usr/local/bin/ take precedence over /usr/bin/
- ~/.local/bin

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

## ln
```
# symlink (soft link)
ln -s <destination/target-dir/file> <link-name>
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
echo "TLS_REQCERT never" >>/etc/(open)ldap/ldap.conf
ldapsearch -x -H ldaps://<ldap-host>:636 -D "CN=TU001,OU=Service_Accounts,OU=Accounts,DC=domain,DC=rootdom,DC=net(user-cn)" -w '<password>(user-password)' -b "DC=rootdom,DC=net(search-base)" "cn=<user-id>(filter)" ["dn(request)"] [-d1]
```

## getent
```
getent hosts <hostname>
getent group <groupname>
```

## apt
```
## apt list
apt list --upgradable
apt list --installed [-qq|--quiet] <(*)package-name(*)>

## apt update
### updates package cache
apt-get update # to fix 404 for install

## apt upgrade
apt-get [-s|--simulate] upgrade
apt-get [-u|--show-upgraded] [-V|--verbose-versions] [[--assume-no]] upgrade # show upgraded version summary
### apt list --installed [-qq|--quiet] <(*)package-name(*)>

## apt install
apt-get [-f|--fix-broken] [-m|--fix-missing] [[--no-cache]] install <package-name>|./<file-name>.deb

## apt remove
apt-get remove <package-name>

## apt purge
apt purge <package1> <packagen>
```

```
echo "deb http://cz.archive.ubuntu.com/ubuntu mantic main" | sudo tee /etc/apt/sources.list.d/temporary-repository.list
sudo apt update
sudo apt install <package1> <packagen> # gcc-13 gcc-13-aarch64-linux-gnu
sudo rm /etc/apt/sources.list.d/temporary-repository.list
sudo apt update
```

## pacman

Settings: `/etc/pacman.conf`.<br />
Packages are stored in `/var/cache/pacman/pkg/`.<br />

```
## query local packages (DB/repo)
pacman -Qs <string> [... <stringn>]
pacman -Qqe > pkglist.txt

## search remote DB/repo
pacman -Ss <string> [... <stringn>]

## display
### local
pacman -Qii <package>
### remote
pacman -Si <package>

## install (=sync remote DB/repo)
### -p (=print)
pacman -S [-p] --needed <package> [...<package_n>]
pacman -S --needed - < pkglist.txt
## reinstall
pacman -S <package>

## sysupgrade
### -S (Sync), -y (refresh), -u (sysupgrade), -p (print)
### never run pacman -Sy and avoid a refresh (-y) without an upgrade (-u)
pacman -Syu

## uninstall
### -R (Remove) -s (remove dependencies not required by other packages) -c (recursive) -n (prevent .pacsave file creation)
pacman -Rs <package>

## clean package cache
### delete cached versions of installed and uninstalled packages, except for the most recent three versions
paccache -r
### delete and retain <n> past versions
paccache -rk<n>

systemctl enable pacman-filesdb-refresh.timer
```

## yay
```
yay -Syu
```

## ca-certificates

- /etc/ssl/cert.pem<br />
Classic filename, file contains a list of CA certificates trusted for TLS server authentication usage, in the simple BEGIN/END CERTIFICATE file format, without distrust information. This file is a symbolic link that refers to the consolidated output created by the update-ca-trust command.

- /etc/ssl/certs/<br />
Classic directory, contains individual CA certificates trusted for TLS server authentication usage, in the simple BEGIN/END CERTIFICATE file format, without distrust information. Also includes the necessary hash symlinks expected by OpenSSL. The files are symbolic links that refer to the output created by the update-ca-trust command.

- /etc/ssl/certs/ca-bundle.crt<br />
Classic filename for compatibility with RHEL/Fedora, file contains a list of CA certificates trusted for TLS server authentication usage, in the simple BEGIN/END CERTIFICATE file format, without distrust information. This file is a symbolic link that refers to the consolidated output created by the update-ca-trust command.

- /etc/ssl/certs/ca-certificates.crt<br />
Classic filename for compatibility with Debian, file contains a list of CA certificates trusted for TLS server authentication usage, in the simple BEGIN/END CERTIFICATE file format, without distrust information. This file is a symbolic link that refers to the consolidated output created by the update-ca-trust command.

- /etc/ssl/certs/java/cacerts<br />
Classic filename, file contains a list of CA certificates trusted for TLS server authentication usage, in the Java keystore file format, without distrust information. This file is a symbolic link that refers to the consolidated output created by the update-ca-trust command.

## update-ca-certificates
```
# /usr/share/ca-certificates/ + /usr/sbin/update-ca-certificates
cp -v root_ca.crt /usr/share/ca-certificates/<sub-dir>/
sudo bash -c "if ! grep <sub-dir>/root_ca.crt /etc/ca-certificates.conf; then echo \"<sub-dir>/root_ca.crt\" >>/etc/ca-certificates.conf; fi;"
sudo update-ca-certificates # updates certificates in /etc/ssl/certs/ca-certificates.crt

# /usr/local/share/ca-certificates/ + /usr/sbin/update-ca-certificates
cp -v root_ca.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates # updates certificates in /etc/ssl/certs/ca-certificates.crt
openssl s_client -connect foo.whatever.com:443 -CApath /etc/ssl/certs
```

## update-ca-trust
```
ls -lah /etc/pki/tls/openssl.cnf
ls -lah /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem

/etc/ssl/openssl.cnf -> /etc/pki/tls/openssl.cnf
/etc/ssl/cert.pem -> /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
/etc/ssl/certs/ca-bundle.crt -> /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem

/etc/pki/tls/cert.pem -> /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
/etc/pki/tls/certs/ca-bundle.crt -> /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
```

## pwgen
```
pwgen -y|--symbols -s|--secure [<pw-length>|32] [<pw-count>|1] # generate one random password with a length of 32 characters including symbols
```

## update-alternatives
```
update-alternatives --config gcc
update-alternatives --install <link-src> <link-name> <link-target> <link-priority>
# link gcc to /etc/alternatives/gcc, which is a symlink to /usr/bin/gcc-10
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 60
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 70 --slave /usr/bin/g++ g++ /usr/bin/g++-13 --slave /usr/bin/gcov gcov /usr/bin/gcov-13
update-alternatives --remove gcc /usr/bin/gcc-13
```

## Wayland
```
echo $XDG_SESSION_TYPE
echo $WAYLAND_DISPLAY
xlsclients # list applications running in a X11 session of the XServer of Xwayland
```

## Docker
```
# add Docker gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# add Docker repository
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# update repository
sudo apt update
# install Docker engine
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin [docker-compose]
# add user to docker group
sudo usermod -aG docker $USER
# check members of the docker group
grep docker /etc/group
# check installation
docker --version
# start docker service
sudo service docker start
# stop docker service
sudo service docker stop
```

## Skopeo
```
# xUbuntu_20.04 or xUbuntu_22.04
echo "deb http://download.opensuse.org/repositories/home:/alvistack/xUbuntu_20.04/ /" | sudo tee /etc/apt/sources.list.d/home:alvistack.list
curl -fsSL https://download.opensuse.org/repositories/home:alvistack/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_alvistack.gpg > /dev/null
sudo apt update
sudo apt install skopeo
```
