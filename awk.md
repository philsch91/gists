# awk

```
kubectl get deployment,sts,ds -A --no-headers | grep -i <regex> | awk '{print $1";"$2}'
for RES in $(k get cm -A | tail -n +2 | awk '{print $1";"$2}'); do NS_NAME=$(echo $RES | awk -F ';' '{print $1}'); CM_NAME=$(echo $RES | awk -F ';' '{print $2}'); echo "NS_NAME: $NS_NAME CM_NAME: $CM_NAME"; sleep 1; done

# -v|--assign <var-name>=<value>
# row = value stored in AWK var row
awk -v row="1" '{print row}'
# $col = field <col-value> in input ($.<col-value>) stored in AWK var col
awk -v row="1" -v col=${args[$#-1]} 'NR >=row && NR<=row {print $col}'
```
