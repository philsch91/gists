# Docker

## Login
```
docker login <docker-registry-uri> -u <user-name> -p <password> [--password-stdin]
```

## Containers

### run
run new container image: `docker run -dt [--entrypoint new-entrypoint|/bin/bash] --name <container-name> [-e <env-var-name>=<env-var-value> ...] [-p 443:443] <image>:<tag>`\
run container image interactively: `docker run [--rm] -it <image>:<tag> [<cmd>]`<br />

### ps
show all running and stopped containers: `docker ps -a`\
stop all running containers: `docker stop (docker ps -aq)`\

### rm
remove container: `docker rm <container-id>`\
remove all containers: `docker rm (docker ps -aq)`<br />

### start
start existing container: `docker start <container-name>`\
### exec
execute bash shell in running container: `docker exec -it <container-name> bash`\
### stop
stop container: `docker stop <container-id>`\

### Image

show all images: `docker image ls`\
remove all images: `docker image rm (docker ps -q)`\
remove image: `docker image rm <image-id>`<br />

```
docker image tag <repo>/<name>:<tag> <registry-host>:<port>/<repo>/<name>:<tag>
docker image push <registry-host>:<port>/<repo>/<name>:<tag>
```

### Skopeo
```
docker login <docker-registry-uri-1>
docker login <docker-registry-uri-2>
skopeo copy docker://<docker-registry-uri-1>/<path>/<image-stream>:<tag> docker://<docker-registry-uri-2>/<path>/<image-stream>:<tag>
```
