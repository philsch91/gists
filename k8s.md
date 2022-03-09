# Kubernetes Gists

## config
```
kubectl config current-context
```

## cluster-info
```
kubectl cluster-info
```

## deployment
```
kubectl [-n <namespace>] get deployment
kubectl get deployment <deployment-name> [-o yaml|json|wide]
kubectl get deployment/<deployment-name> [-o yaml|json|wide]
kubectl delete deployment/<deployment-name>
```

## pods
```
kubectl get pod
kubectl get pod <pod-name>
kubectl get pod/<pod-name>
```

## exec
```
kubectl exec <pod> [-c <container>] -- <command>
kubectl exec <pod> [-c <container>] -- date
kubectl exec <pod> -- nc -zv <host> <port>
//switch to raw terminal mode; sends stdin to 'bash' in container <container> from pod <pod> and sends stdout/stderr from 'bash' back to the client
kubectl exec <pod> [-c <container>] -it -- /bin/bash -il
kubectl exec <pod> [-c <container>] -it bash
// Git Bash
kubectl exec <pod> [-c <container>] -it -- bash -il
// Git Bash + winpty
winpty kubectl exec <pod> -c <container> -it -- bash -il
```

## logs
```
kubectl logs [-f] --tail 100 [-p] <pod | type/name> [-c <container>]
kubectl logs [-f] --since=2h -l app=nginx --all-containers=true
```

## scale
```
kubectl scale --replicas=<count> deployment|rs|rc|statefulset/<name>
```

## configmap
```
kubectl get configmap
kubectl get configmap/<configmap-name> [-o yaml]
```

## create
```
kubectl create secret docker-registry <secretname> --docker-server=<host> \
    --docker-username=<username> --docker-password='<password>'
```

## apply
```
kubectl apply -f <file>
cat file.yml | kubectl apply -f -
```

## patch
```
kubectl -n <namespace> patch <resource>/<resource-name> --type=json --patch='[{"op":"replace","path":"/<key1>/<key2>","value":<value>}]'
```

## auth
```
kubectl auth can-i get pods --as system:<system-account-name>:namespace:<namespace-name>
```

## ReST API
```
api/v1/namespaces/<namespace-name>/status
apis/apps/v1/namespaces/<namespace-name>/deployments
```
