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

## api-resources
```
kubectl api-resources | grep -i <resource-name>
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
kubectl get deployment/<deployment-name> -o jsonpath='{.spec.template.spec.containers[*].name}'
kubectl get deployment/<deployment-name> -o jsonpath='{.spec.template.spec.containers[0].args}'
kubectl get deployment/<deployment-name> -o jsonpath='{.spec.template.spec.containers[0].image}'
kubectl get deployment/<deployment-name> -o jsonpath='{.spec.template.metadata.annotations}'
kubectl delete deployment/<deployment-name>
```

### get pods
```
kubectl get pod
kubectl get pod <pod-name>
kubectl get pod/<pod-name>
kubectl get pod/<pod-name> -o jsonpath='{.spec.containers[*].name}'
```

## describe
```
// check for overcommitted resource limits (undercommitted nodes)
kubectl describe node/<node-name>
```

## exec
```
kubectl exec <pod> [-c <container>] -- <command> <arg1> <arg2> ... <argn>
kubectl exec <pod> [-c <container>] -- date
kubectl exec <pod> [-c <container>] -- cat /var/log/system.log
kubectl exec <pod> [-c <container>] -- nc -zv <host> <port>
kubectl exec <pod> [-c <container>] -it bash
// switch to raw terminal mode
// sends stdin to 'bash' in container <container> from pod <pod> (exec -it) and sends stdout/stderr from 'bash' back to the client (bash -il)
// --stdin = -i, --tty = -t
kubectl exec <pod> [-c <container>] -it -- /bin/bash -il
// Git Bash + winpty
winpty kubectl exec <pod> [-c <container>] -it -- bash -il
```

## debug
```
// add an ephemeral debug container to a running Pod for debugging another container in the Pod
// The --target parameter targets the process namespace of the given container.
// It is necessary for `kubectl run` as it does not enable process namespace sharing in the Pod it creates.
kubectl debug -it <pod-name> --image=busybox:1.28 --target=<container-name-to-debug>

// create a copy of a pod while adding a new container
// The `--share-processes` flag allows the containers in this Pod to see processes from the other containers in the Pod.
kubectl debug -it <pod-name-to-copy> --image=ubuntu --share-processes --copy-to=<pod-name>-debug

// create a copy of a pod while changing the container images
// The value `*=ubuntu` for the `--set-image` flag changes all container images
kubectl debug <pod-name-to-copy> --copy-to=<pod-name>-debug --set-image=*=ubuntu

// create a copy of a pod and container while changing the command
kubectl debug -it <pod-name-to-copy> --copy-to=<pod-name>-debug --container=<container-name-to-copy> -- sh
kubectl annotate --overwrite pod <pod-name>-debug livenessprobe=disabled

// create a copy of pod with changed probes avoiding restarts
kubectl get pod/<pod-name>-debug -o json | kubectl patch --type=json -f - -p='[{"op": "replace", "path": "/spec/containers/0/livenessProbe", "value": {"exec":{"command":["/bin/sh", "-c", "cat /opt/toolchain-base/bin/liveness_probe.sh"]}}}, {"op": "replace", "path": "/spec/containers/0/readinessProbe", "value": {"exec":{"command":["/bin/sh", "-c", "cat /opt/toolchain-base/bin/readiness_probe.sh"]}}}, {"op": "replace", "path": "/metadata/name", value: "<pod-name>-debug-2"}]' --dry-run=client -o yaml | kubectl apply -f -
```

### debug container
```yaml
- name: container-name
  command: ["sh"]
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

// patch op replace pod probe
k patch pod/<pod-name> --type=json --patch='[{"op": "replace", "path": "/spec/containers/0/livenessProbe", "value": {"exec":{"command":["/bin/sh", "-c", "cat /opt/toolchain-base/bin/liveness_probe.sh"]}}}]'

// patch merge pod probe
k patch pod/<pod-name> --type=merge -p='{"spec": {"containers": [{"name": "container-name", "livenessProbe": {"httpGet": {"path": "/healthz", "port": 8080}, "initialDelaySeconds": 10, "periodSeconds": 5}}]}}'

// patch op add service account to cluster role binding
kubectl -n kubernetes-dashboard patch clusterrolebinding/basic-user --type='json' -p='[{"op":"add","path":"/subjects/-","value":{"kind":"ServiceAccount","name":"kubernetes-dashboard","namespace":"kubernetes-dashboard"}}]'

// patch op add (replace) service accounts in cluster role binding
kubectl -n kubernetes-dashboard patch clusterrolebinding/basic-user --type=json -p='[{"op":"add","path":"/subjects","value":[{"kind":"ServiceAccount","name":"basic-user","namespace":"kubernetes-dashboard"},{"kind":"ServiceAccount","name":"kubernetes-dashboard","namespace":"kubernetes-dashboard"}]}]"

// disable pod scheduling for daemonset by adding temporary non-existing `nodeSelector`
kubectl -n <namespace> patch daemonset <ds-name> -p '{"spec": {"template": {"spec": {"nodeSelector": {"non-existing": "true"}}}}}'

// enable pod scheduling for daemonset by removing temporary non-existing `nodeSelector`
kubectl -n <namespace> patch daemonset <ds-name> --type json -p='[{"op": "remove", "path": "/spec/template/spec/nodeSelector/non-existing"}]'
```

## cp
```
// copy from pod to local system
kubectl -n <namespace> cp <pod-name>:/<container>/<path>/<file-name> ./<file-name> --retries 999

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
kubectl drain [--ignore-daemonsets] [--delete-emptydir-data] [--delete-local-data] [--disable-eviction] <node-name>
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

## K8s notes

I think you mean my attempt to explain that Karpenter primarily provisiones the cluster nodes based on the sum of the resource requests for existing and new workloads. The cluster cannot scale out for already running workloads and without new resource requests.<br />

One exception to that is that if a container allocates more resources and especially more memory than available on the node and if the pod is evicted, the pod is recreated by the controlling resource such as a deployment to meet the requirements of a replicaset, the cluster is potentially scaled out, and the replacing pod is scheduled on a new node, which is usually avoided or is actually unintentional and undesirable.
