# awk

```
kubectl get deployment,sts,ds -A --no-headers | grep -i <regex> | awk '{print $1";"$2}'
for RES in $(k get cm -A | tail -n +2 | awk '{print $1";"$2}'); do NS_NAME=$(echo $RES | awk -F ';' '{print $1}'); CM_NAME=$(echo $RES | awk -F ';' '{print $2}'); echo "NS_NAME: $NS_NAME CM_NAME: $CM_NAME"; sleep 1; done
```
