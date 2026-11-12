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
docker inspect --format='{{.Config.User}}' [<registry-host>/][<repo>/]<image-name>:<tag>
docker inspect --format '{{.Os}}/{{.Architecture}}' [<registry-host>/][<repo>/]<image-name>:<tag> # linux/amd64
```

### /etc/systemd/system/docker.service.d/override.conf + systemctl restart docker
```
sudo mkdir -pv /etc/systemd/system/docker.service.d
echo -e "[Service]\nExecStart=\nExecStart=/usr/bin/dockerd -H fd:// --max-concurrent-uploads=1 --mtu=1000" | sudo tee /etc/systemd/system/docker.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### Dockerfile
```
FROM registry.access.redhat.com/ubi9/ubi:latest

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

ENV UID=1001 \
    GID=1001 \
    USERNAME="runner" \
    DOCKER_GID=123

ENV CURL_CA_BUNDLE=/etc/pki/tls/certs/ca-bundle.crt \
    AWS_CA_BUNDLE=/etc/pki/tls/certs/ca-bundle.crt \
    REQUESTS_CA_BUNDLE=/etc/pki/tls/certs/ca-bundle.crt \
    SSL_CERT_FILE=/etc/pki/tls/certs/ca-bundle.crt

ENV RUNNER_MANUALLY_TRAP_SIG=1 \
    ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1 \
    ImageOS=ubi9 \
    BUILDKITD_FLAGS=--oci-worker-no-process-sandbox \
    BUILDCTL_CONNECT_RETRIES_MAX=4 \
    TMPDIR=/tmp \
    TMPDIR_USER=/home/${USERNAME}/.local/tmp \
    XDG_RUNTIME_DIR=/home/${USERNAME}/.local/run \
    container=podman \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/share/maven/bin:/usr/local/go/bin

ENV BUILDKIT_HOST=unix://${XDG_RUNTIME_DIR}/buildkit/buildkitd.sock

# Create user and home in one layer
RUN set -eux && \
    groupadd -g $GID $USERNAME && \
    groupadd -g $DOCKER_GID docker && \
    useradd -u $UID --create-home --shell /bin/bash -g $GID --groups docker $USERNAME && \
    # chown -R $UID:$GID /home/$USERNAME && \
    chgrp -R 0 /home/$USERNAME && \
    chmod -R g=u /home/$USERNAME && \
    echo "${USERNAME} ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    grep -q "^${USERNAME}:" /etc/subuid || echo "${USERNAME}:100000:65536" >> /etc/subuid && \
    grep -q "^${USERNAME}:" /etc/subgid || echo "${USERNAME}:100000:65536" >> /etc/subgid

RUN set -eux && \
    chgrp 0 /etc/passwd && \
    chmod g=u /etc/passwd

RUN set -eux && \
    mkdir -p ${XDG_RUNTIME_DIR} && \
    chown ${UID}:${GID} /home/${USERNAME}/.local ${XDG_RUNTIME_DIR} && \
    chgrp 0 /home/${USERNAME}/.local ${XDG_RUNTIME_DIR} && \
    chmod g=u /home/${USERNAME}/.local && \
    chmod 0770 ${XDG_RUNTIME_DIR}

WORKDIR /home/${USERNAME}
USER ${USERNAME}
```

## info
```
docker info [| grep -i registry]
docker info --format '{{.OSType}}/{{.Architecture}}' # linux/x86_64
```

## login
```
docker login <docker-registry-uri> -u <user-name> -p <password> [--password-stdin]
```

## pull
```
docker pull <registry-host>:<port>/<repo>/<image-name>:<tag>
```

## build
```
docker build --pull --progress=plain -f <dockerfile-path> -t <image-name>:<image-tag> [--build-arg http_proxy= --build-arg https_proxy=] <build-context-path>|. [2>&1 | tee -a /tmp/docker-build.log]
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
docker image tag [<repo>/]<image-name>:<tag> <registry-host>:<port>/<repo>/<image-name>:<tag>
docker image push <registry-host>:<port>/<repo>/<image-name>:<tag>
docker image tag <registry-host>:<port>/<repo>/<image-name>:<tag1> <registry-host>:<port>/<repo>/<image-name>:<tag2>
docker image push <registry-host>:<port>/<repo>/<image-name>:<tag2>
```

## skopeo
```
docker login <docker-registry-uri-1>
docker login <docker-registry-uri-2>
skopeo copy docker://<docker-registry-uri-1>/<path>/<image-stream>:<tag> docker://<docker-registry-uri-2>/<path>/<image-stream>:<tag>
skopeo [--debug] copy --retry-times 5 --retry-delay 5s --image-parallel-copies 1 --dest-creds "AWS:$(aws ecr get-login-password --region eu-central-1)" docker-daemon:<image-name>:latest docker://<registry-host>/<repo>/<image-name>:latest
```

## regctl
```
## regctl files
ls $HOME/.regctl/config.json
command -v regctl # /home/<username>/.local/bin/regctl
regctl version
regctl registry config
regctl registry set <registry-host> --blob-chunk 20000000 --blob-max 1000000
regctl registry login
aws ecr get-login-password --region eu-central-1 | regctl registry login <registry-host> -u AWS --pass-stdin
docker build --pull -f Dockerfile -t <image-name>:latest .
docker save [<registry-host>/][<repo>/]<image-name>:latest -o /tmp/<image-name>_<tag>.tar
ls -lh /tmp/<image-name>_<tag>.tar
regctl image import ocidir:///tmp/<image-name>:latest /tmp/<image-name>_<tag>.tar
regctl manifest get ocidir:///tmp/<image-name>:latest
# push
regctl image copy [--platform linux/amd64|linux/arm64] ocidir:///tmp/<image-name>:latest <registry-host>/<repo>/<image-name>:latest
regctl image copy [--platform linux/amd64|linux/arm64] [<registry-host>/][<repo>/]<image-name>:latest <registry-host>/<repo>/<image-name>:<tag>
# copy
regctl image copy <registry-host>/<repo>/<image-name>:latest <registry-host>/<repo>/<image-name>:<tag>
```

## Notes

### Problem: Connection reset for `docker image push`
```
write tcp 172.30.230.84:52646->3.122.9.124:443: write: connection reset by peer
```

### Solution: Set MTU of eth0 to 1300 Bytes
```
sudo ip link set dev eth0 mtu 1300

ip link show eth0
# 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1300 qdisc mq state UP mode DEFAULT group default qlen 1000
#     link/ether 00:15:5d:55:53:19 brd ff:ff:ff:ff:ff:ff

ip addr show eth0 | grep mtu
# 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1300 qdisc mq state UP group default qlen 1000
```

### Solution: Deactivate checksum offloading in WSL to Windows
```
sudo ethtool -K eth0 tx off rx off
```
