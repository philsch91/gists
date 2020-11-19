# Docker Notes

### Containers

run container image: `docker run -p 443:443 <image>`
show all running and stopped containers: `docker ps -a`
stop all running containers: `docker stop (docker ps -aq)`
remove container: `docker rm <container-id>`
remove all containers: `docker rm (docker ps -aq)`

### Images

show all images: `docker image ls`
remove all images: `docker image rm (docker ps -q)`
remove image: `docker image rm <image-id>`
