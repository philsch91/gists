# OpenShift

## Login

### Minishift: give user cluster admin rights
```
oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin XXX
```

Get from `https://<url>:8443/console/command-line` the token.
```
oc login ...
oc login https://<url> --token=<token>
```

## Project

### Create project
```
oc new-project xxx --description="XXX" --display-name="xxx xxx xxx"
```

### Change project
```
oc project <project-name>
```

## New-App

### Create app and build from source on GitHub

Launches as pod supervised by DC.

```
oc new-app --strategy=source IMAGE:TAG~https://github.com/user/project.git
# for example:
oc new-app --strategy=source python:2.7~https://github.com/user/project.git -e APP_FILE=project.py -e PORT=8080
```

### Create app definition from Dockerfile
```
oc new-app --strategy=docker --name='$(app_name)' --context-dir='./app/' . --output yaml > app.yaml
oc apply -f app.yaml
```

### Build from image from local dir
```
oc new-build --strategy=docker --name='xxx' .
oc start-build xxx --from-dir .
```

## Get and Apply

### Get and apply objects
```
oc -n <project-name> get dc <dc-name> -o yaml --export
oc -n <project-name> get dc redis -o yaml --export >dc-redis.yaml
oc -n <project-name> get pvc redis -o yaml --export >pvc-redis.yaml
oc -n <project-name> get service redis -o yaml --export >service-redis.yaml
oc -n <project-name> get secret redis -o yaml --export >secret-redis.yaml
oc get dc,pvc,svc,route,configmap -l "<label-name> in (<label-value> [, <label-value-2>])" -o json >><label-name>-<label-value>.json
```

### Apply objects
```
oc -n <project-name> apply -f secret-redis.yaml
oc -n <project-name> apply -f service-redis.yaml
oc -n <project-name> apply -f pvc-redis.yaml
oc -n <project-name> apply -f dc-redis.yaml
```

## Secret

```
oc -n <namespace-name> get secret/builder-dockercfg-<id> -o json | jq -r '.data.".dockercfg" | @base64d' | jq -r '."docker-registry.default.svc.cluster.local:5000".password'
```

## Template

```
oc get template -n openshift | grep redis
oc get template redis-persistent -o yaml -n openshift > path/to/redis-persistent-template.yml
```

### Process and apply templates
```
oc project <project-name>
oc process -f path/to/redis-persistent-template.yml -p REDIS_PASSWORD=redis | oc create -f -
```

## Run

### Run simple
TODO: how to find image?
```
oc run rs --image=172.30.115.115:5000/go-test/reshifter
```

## Log

### Check deployment
```
oc status
oc logs -f dc/xxx
```
```
oc logs <pod-name> -c <container-name>
```

### Follow build logs
```
oc logs -f bc/xxx
```

## Rollout

### Pause rollouts
```
oc rollout pause dc <dc-name>
```

### Resume rollouts
```
oc rollout resume dc <dc-name>
```

### Rollout deployment config
```
oc rollout latest dc/<dc-name> -n <project-name>
```

## Pod

### Delete evicted pods
```
oc get pods [-n <project-name>] | grep -i Evicted | awk '{print $1}' | xargs oc delete pod [-n <project-name>]
```
### Restart pod
The replication controller should make sure, that a new pod is started to maintain the set number of replicas in the deployment config.
```
oc delete pod <pod-name>
```

## Trigger

## Get triggers
```
oc set triggers dc --all
```

## Disable automatic triggers
```
oc set triggers dc <dc-name> --manual
```

## Enable automatic triggers
```
oc deploy --enable triggers
```

### Create service from DC
```
oc expose dc rs --port=8080
```

## Route

```
oc expose svc/xxx
oc annotate route <route-name> router.openshift.io/cookie_name=JSESSIONID -n <project-name>
oc annotate route <route-name> --overwrite haproxy.router.openshift.io/timeout=2m -n <project-name>
oc annotate route <route-name> --overwrite haproxy.router.openshift.io/balance=roundrobin -n <project-name>
```

### Find FQDN

```
oc get routes | grep xxx | awk '{print $2}'
```

Hit `/info` endpoint of the service, using two different methods:

```
http $(oc get routes | grep xxx | awk '{print $2}')/info
curl -s $(oc get routes | grep xxx | awk '{print $2}')/info | jq .
```

## Scale

### Scale resources
```
oc scale --replicas=<count> [deployment|replicaset|replicationcontroller|statefulset|deploymentconfig|dc]/<object-name> -n <project-name>
```

## HPA

### Autoscale resources
```
oc get horizontalpodautoscaler | awk '{print $2}'
oc get horizontalpodautoscaler -o template --template '{{range .items}}{{.spec.scaleTargetRef.name}}{{"\n"}}{{end}}'
```

## Quota

### Adapt Quotas
```
oc get quota    # get quota names
oc get quota -o yaml    # get yaml description of quotas (ResourceQuota)
oc get -o yaml quota <object-name> -n <project-name>
oc delete quota <quota-name> -n <project-name>
oc create -f <file-name> -n <project-name>          # apply quotas (ResourceQuota) in template yaml file
oc describe quota <quota-name> -n <project-name>    # verify quotas
oc describe quota   # verify quotas
```

## Rsync

### Copy files from container
```
oc rsync <pod-name>:/tmp/output.txt /tmp
```

### Copy files to container
```
oc rsync . <pod-name>:/appbase/system_admin/ --exclude=* --include=security.xml -c <container-name>
```

## Policy

### Add Service Account
```
oc create sa <service-account-name>
oc describe sa <service-account-name>
oc policy add-role-to-user view system:serviceaccount:<project-name>:<service-account-name>
```
### Add role to user in projects
```
for projectname in $(oc get projects | awk '$1 != "NAME" {print $1}'); do echo ${projectname}; oc adm policy add-role-to-user admin firstname.surname@domain.com -n ${projectname}; done
```

## Docker Images

### Import Image
```
oc tag docker-registry.default.svc:<registry-port>/<project>/<image>:<tag> <project>/<image>:<tag>
oc import-image <project>/<image>:<tag> --from=docker-registry-default.<registry-domain>/<project>/<image>:<tag> --insecure --confirm
```

### Delete Image Tag
```
oc delete istag/<image>:<tag>
oc tag -d <image>:<tag>
```

### Get Image Streams
```
oc get imagestreams/<image> -o jsonpath='{range .status.tags[*]}{.tag}{"\n"}'
```

### Docker Push and Pull
```
docker login -u openshift[|$(oc whoami)] -p $(oc whoami -t) [--insecure-skip-tls-verify=true] <registry-name>.<registry-domain>:<registry-port>
docker pull <project><image>:<tag>
docker tag <project><image>:<tag> <registry-name>.<registry-domain>:<registry-port>/<project>/<image>:<tag>
docker push <registry-name>.<registry-domain>:<registry-port>/<project>/<image>:<tag>
```
