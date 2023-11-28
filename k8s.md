# Kubernetes Gists

## config
```
kubectl config current-context
kubectl config get-contexts

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

## get

```
for r in $(kubectl -n <namespace> get deployment,sts,ds | tail -n +2 | awk '{print $1}'); do echo $r; kubectl -n <namespace> get $r -o jsonpath='{.spec.template.spec.containers[0].image}'; echo; done
```

### get deployment
```
kubectl [-n <namespace>] get deployment
kubectl get deployment <deployment-name> [-o yaml|json|wide]
kubectl get deployment/<deployment-name> [-o yaml|json|wide]
kubectl get deployment/<deployment-name> -o jsonpath='{.spec.template.spec.containers[0].args}'
kubectl get deployment/<deployment-name> -o jsonpath='{.spec.template.spec.containers[0].image}'
kubectl delete deployment/<deployment-name>
```

### get pods
```
kubectl get pod
kubectl get pod <pod-name>
kubectl get pod/<pod-name>
```

## describe
```
// check for overcommitted resource limits (undercommitted nodes)
kubectl describe node/<node-name>
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

## rollout
```
// restart daemonset
kubectl -n <namespace> rollout restart daemonset/<daemonset-name>
// watch daemonset restart
kubectl -n <namespace> rollout status daemonset/<daemonset-name>
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

## secret
```
kubectl -n <namespace-name> get secret/<secret-name> -o json | jq -r '.data.password | @base64d'
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
kubectl -n <namespace> patch <resource-type>/<resource-name> --type='json' --patch='[{"op":"replace","path":"/<key1>/<key2>","value":<value>}]'
kubectl -n <namespace> patch <resource-type>/<resource-name> --type=json -p='[{"op":"add","path":"/<key1>/<key2>","value":<value>|{"key1":"val1"}|[<value1>,<value2>]}]'

// patch op add token-ttl=0 and enable-skip-login for kubernetes-dashboard
kubectl -n kubernetes-dashboard patch deployment/kubernetes-dashboard --type=json -p='[ \
    {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--token-ttl=0"}, \
    {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--enable-skip-login"} \
]'

// patch op add (replace) namespace=kubernetes-dashboard, auto-generate-certificates, authentication-mode=basic, token-ttl=0, enable-skip-login and enable-insecure-login for kubernetes-dashboard
kubectl -n kubernetes-dashboard patch deployment/kubernetes-dashboard --type='json' -p='[{"op":"add","path":"/spec/template/spec/containers/0/args","value":["--namespace=kubernetes-dashboard","--auto-generate-certificates","--authentication-mode=basic","--token-ttl=0","--enable-skip-login","--enable-insecure-login"]}]'

// patch op add service account to cluster role binding
kubectl -n kubernetes-dashboard patch clusterrolebinding/basic-user --type='json' -p='[{"op":"add","path":"/subjects/-","value":{"kind":"ServiceAccount","name":"kubernetes-dashboard","namespace":"kubernetes-dashboard"}}]'

// patch op add (replace) service accounts in cluster role binding
kubectl -n kubernetes-dashboard patch clusterrolebinding/basic-user --type=json -p='[{"op":"add","path":"/subjects","value":[{"kind":"ServiceAccount","name":"basic-user","namespace":"kubernetes-dashboard"},{"kind":"ServiceAccount","name":"kubernetes-dashboard","namespace":"kubernetes-dashboard"}]}]"
```

## cp
```
// copy from pod to local system
kubectl -n <namespace> cp <pod-name>:/<container>/<path>/<file-name> ./<file-name>

// copy from local system to container
kubectl -n <namespace> cp /local/path/<file-name> <pod-name>:/<container>/<path> -c <container-name>
```

## auth
```
// current namespace
kubectl auth can-i '*' '*'
kubectl auth can-i list deployments.extensions
kubectl auth can-i get pods [--as system:<serviceaccount-name>:namespace:<namespace-name>]

// any namespace
kubectl auth can-i create deployments [--as <user>] --all-namespaces

// specific namespace
kubectl auth can-i create pods [--as <user>] --namespace default
kubectl auth can-i list secrets [--as <user>] --namespace default
kubectl auth can-i create deployments [--as system:serviceaccount:<namespace-name>:<serviceaccount-name>] --namespace default
```

## customresourcedefinition
```
kubectl get customresourcedefinition
```

## top
```
kubectl top node <node-name>
kubectl -n <namespace> top pod <pod> --containers 2>/dev/null
```

## drain
```
kubectl cordon <node-name>
kubectl drain [--ignore-daemonsets] [--delete-emptydir-data] [--delete-local-data] <node-name>
// power down or terminate node or delete VM backing the node if needed
// resume pod scheduling
kubectl uncordon <node-name>
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
