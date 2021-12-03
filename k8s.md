# Kubernetes Gists

kubectl deployment
```
kubectl [-n <namespace>] get deployment
kubectl get deployment/<deployment-name> [-o yaml|wide]
```

kubectl pods
```
kubectl get pods
```

kubectl exec
```
kubectl exec <pod> [-c <container>] -- date
//switch to raw terminal mode; sends stdin to 'bash' in container <container> from pod <pod> and sends stdout/stderr from 'bash' back to the client
kubectl exec <pod> [-c <container>] -it -- /bin/bash -il
kubectl exec <pod> [-c <container>] -it bash
```

kubectl configmap
```
kubectl get configmap
kubectl get configmap/<configmap-name> [-o yaml]
```