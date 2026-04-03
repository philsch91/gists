# Docker

## Files

- /etc/environment
- /etc/default/docker # only for /etc/init.d/docker
- /var/log/docker.log
- /etc/init.d/docker
- /lib/systemd/system/docker.service
- /usr/lib/systemd/system/docker.service
- /etc/systemd/system/docker.service.d/http-proxy.conf
- /home/<username>/.docker/config.json
- /root/.docker/config.json
- /etc/docker/daemon.json

### /etc/docker/daemon.json + /etc/init.d/docker
```
echo '{"max-concurrent-uploads": 3, "mtu": 1400}' | sudo tee /etc/docker/daemon.json
/etc/init.d/docker restart
docker info | grep -i "Concurrent"
docker info --format '{{json .}}' | grep -i "MaxConcurrentUploads"
docker info --format '{{.MaxConcurrentUploads}}'
docker network inspect bridge | grep -i mtu
```

### /etc/systemd/system/docker.service.d/override.conf + systemctl restart docker
```
sudo mkdir -pv /etc/systemd/system/docker.service.d
echo -e "[Service]\nExecStart=\nExecStart=/usr/bin/dockerd -H fd:// --max-concurrent-uploads=1 --mtu=1000" | sudo tee /etc/systemd/system/docker.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## info
```
docker info [| grep -i registry]
```

## login
```
docker login <docker-registry-uri> -u <user-name> -p <password> [--password-stdin]
```

## build
```
docker build -f <dockerfile-path> -t <image-name>:<image-tag> [--build-arg http_proxy= --build-arg https_proxy=] <build-context-path>|.
```

## run
run new container image: `docker run -dt [--entrypoint new-entrypoint|/bin/bash] --name <container-name> [-e <env-var-name>=<env-var-value> ...] [-p 443:443] <image>:<tag>`\
run container image interactively: `docker run [--rm] -it <image>:<tag> [<cmd>]`<br />

## ps
show all running and stopped containers: `docker ps -a`\
stop all running containers: `docker stop (docker ps -aq)`\

## rm
remove container: `docker rm <container-id>`\
remove all containers: `docker rm (docker ps -aq)`<br />

## start
start existing container: `docker start <container-name>`\
### exec
execute bash shell in running container: `docker exec -it <container-name> bash`\
### stop
stop container: `docker stop <container-id>`\

## image

show all images: `docker image ls`\
remove all images: `docker image rm (docker ps -q)`\
remove image: `docker image rm <image-id>`<br />

### image tag and push
```
docker image tag [<repo>/]<name>:<tag> <registry-host>:<port>/<repo>/<name>:<tag>
docker image push <registry-host>:<port>/<repo>/<name>:<tag>
```

## skopeo
```
docker login <docker-registry-uri-1>
docker login <docker-registry-uri-2>
skopeo copy docker://<docker-registry-uri-1>/<path>/<image-stream>:<tag> docker://<docker-registry-uri-2>/<path>/<image-stream>:<tag>
```

## Notes

### Problem: Connection reset for `docker image push`
```
write tcp 172.30.230.84:52646->3.122.9.124:443: write: connection reset by peer
```

### Solution: Set MTU of eth0 to 1300 Bytes
```
sudo ip link set dev eth0 mtu 1300
ip addr show eth0 | grep mtu
# 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1300 qdisc mq state UP group default qlen 1000
```

### Solution: Deactivate checksum offloading in WSL to Windows
```
sudo ethtool -K eth0 tx off rx off
```
