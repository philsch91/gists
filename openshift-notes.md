# OpenShift Notes

## Minishift: give user XXX cluster admin rights

```
oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin XXX
```

## Log in via CLI

Get from `https://<url>:8443/console/command-line` the token.

```
oc login ...
oc login https://<url> --token=<token>
```

## Create project

```
oc new-project xxx --description="XXX" --display-name="xxx xxx xxx"
```

## Change project

```
oc project <project-name>
```

## Create app and build from source on GitHub

Launches as pod supervised by DC:

```
oc new-app --strategy=source IMAGE:TAG~https://github.com/user/project.git
# for example:
oc new-app --strategy=source python:2.7~https://github.com/user/project.git -e APP_FILE=project.py -e PORT=8080
```


## Create app definition from Dockerfile

```
oc new-app --strategy=docker --name='$(app_name)' --context-dir='./app/' . --output yaml > app.yaml
oc apply -f app.yaml
```

## Build from image from local dir

```
oc new-build --strategy=docker --name='xxx' .
oc start-build xxx --from-dir .
```

## Get and apply objects

```
oc get dc <dc-name> -o yaml --export -n <project-name>

oc get dc redis -o yaml --export -n <project-name> > dc-redis.yaml
oc get pvc redis -o yaml --export -n <project-name> > pvc-redis.yaml
oc get service redis -o yaml --export -n <project-name> > service-redis.yaml
oc get secret redis -o yaml --export -n <project-name> > secret-redis.yaml
oc get dc,pvc,svc,route,configmap -l "<label-name> in (<label-value> [, <label-value-2>])" -o json >> <label-name>-<label-value>.json

oc apply -f secret-redis.yaml -n <project-name>
oc apply -f service-redis.yaml -n <project-name>
oc apply -f pvc-redis.yaml -n <project-name>
oc apply -f dc-redis.yaml -n <project-name>
```

### Get templates
```
oc get template -n openshift | grep redis
oc get template redis-persistent -o yaml -n openshift > path/to/redis-persistent-template.yml
```

### Process and apply templates
```
oc project <project-name>
oc process -f path/to/redis-persistent-template.yml -p REDIS_PASSWORD=redis | oc create -f -
```

## Follow build logs

```
oc logs -f bc/xxx
```

## Run simple

TBD: how to find image?

```
oc run rs --image=172.30.115.115:5000/go-test/reshifter
```

## Check deployment

```
oc status
oc logs -f dc/xxx
```
```
oc logs <pod-name> -c <container-name>
```

## Pause rollouts

```
oc rollout pause dc <dc-name>
```

## Resume rollouts

```
oc rollout resume dc <dc-name>
```

## Rollout deployment config

```
oc rollout latest dc/<dc-name> -n <project-name>
```

## Restart pod

The replication controller should make sure, that a new pod is started to maintain the set number of replicas in the deployment config.
```
oc delete pod <pod-name>
```

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

## Create service from DC

```
oc expose dc rs --port=8080
```

## Create route

```
oc expose svc/xxx
```

## Find FQDN

```
oc get routes | grep xxx | awk '{print $2}'
```

Hit `/info` endpoint of the service, using two different methods:

```
http $(oc get routes | grep xxx | awk '{print $2}')/info
curl -s $(oc get routes | grep xxx | awk '{print $2}')/info | jq .
```

## Scale resources

```
oc scale --replicas=<count> [deployment|replicaset|replicationcontroller|statefulset|deploymentconfig|dc]/<object-name> -n <project-name>
```

## Adapt Quotas

```
oc get quota    # get quota names
oc get quota -o yaml    # get yaml description of quotas (ResourceQuota)
oc get -o yaml quota <object-name> -n <project-name>
oc delete quota <quota-name> -n <project-name>
oc create -f <file-name> -n <project-name>          # apply quotas (ResourceQuota) in template yaml file
oc describe quota <quota-name> -n <project-name>    # verify quotas
oc describe quota   # verify quotas
```

## Sync files

### Copy files from container
```
oc rsync <pod-name>:/tmp/output.txt /tmp
```

### Copy files to container
```
oc rsync . <pod-name>:/appbase/system_admin/ --exclude=* --include=security.xml -c <container-name>
```

## Set policy

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
