# Kubernetes Gists

## config
```
kubectl config current-context

// set cluster
kubectl config [--kubeconfig=config-demo] set-cluster <cluster-name> --server=https://<host>:<port> [--insecure-skip-tls-verify=true]
// set credentials
kubectl config [--kubeconfig=config-demo] set-credentials <credentials-name> [--client-certificate=path/to/certfile] [--client-key=path/to/keyfile] [--token=bearer_token] [--username=basic_user] [--password=basic_password]
// set context
kubectl config [--kubeconfig=config-demo] set-context <context-name> --cluster=<cluster-name> --user=<credentials-name>
// use context
kubectl config [--kubeconfig=config-demo] use-context <context-name>
// view config
kubectl config [--kubeconfig=config-demo] view --minify
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

## top
```
kubectl -n <namespace> top pod <pod> --containers
```

## ReST API
```
api/v1/namespaces/<namespace-name>/status
apis/apps/v1/namespaces/<namespace-name>/deployments
```

## plugin
```
kubectl plugin list
mv kubelogin kubectl-oidc_login
// Windows
setx /M path "%path%;C:\path\to\kubectl-oidc_login.exe"
```