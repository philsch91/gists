# awk

```
kubectl get deployment,sts,ds -A --no-headers | grep -i <regex> | awk '{print $1";"$2}'
```
