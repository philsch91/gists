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
oc new-app --strategy=source IMAGE:TAG~https://github.com/handle/repo.git
# for example:
oc new-app --strategy=source python:2.7~https://github.com/mhausenblas/cwc.git -e APP_FILE=cwc.py -e CWCPORT=8080
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

## Adapt Quotas

```
oc get quota    # get quota names
oc get quota -o yaml    # get yaml description of quotas (ResourceQuota)
oc delete quota <quota-name> -n <project-name>
oc create -f <file-name> -n <project-name>          # apply quotas (ResourceQuota) in template yaml file
oc describe quota <quota-name> -n <project-name>    # verify quotas
oc describe quota   # verify quotas
```
