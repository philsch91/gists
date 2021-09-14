# Docker Notes

## Docker Login
```
docker login <docker-registry-uri> -u <user-name> -p <password> [--password-stdin]
```

### Containers

run new container image: `docker run -dt --name <container-name> -e <env-var-name>=<env-var-value> -e <env-var-name-2>=<env-var-value-2> -p 443:443 <image>:<tag>`\
show all running and stopped containers: `docker ps -a`\
stop all running containers: `docker stop (docker ps -aq)`\
remove container: `docker rm <container-id>`\
remove all containers: `docker rm (docker ps -aq)`\

start existing container: `docker start <container-name>`\
start bash shell in running container: `docker exec -it <container-name> bash`\
stop container: `docker stop <container-id>`\

### Images

show all images: `docker image ls`\
remove all images: `docker image rm (docker ps -q)`\
remove image: `docker image rm <image-id>`\

### Skopeo
```
docker login <docker-registry-uri-1>
docker login <docker-registry-uri-2>
skopeo copy docker://<docker-registry-uri-1>/<path>/<image-stream>:<tag> docker://<docker-registry-uri-2>/<path>/<image-stream>:<tag>
```
