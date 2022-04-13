# K8s Service Account Access

### Create serviceaccount and clusterrolebinding
```
kubectl -n default apply -f serviceaccount.yaml
kubectl -n default apply -f serviceaccount-clusterrolebinding.yaml
```

### Set cluster
```
kubectl config set-cluster absmo-dev-b-cluster --server=https://<host>:<port> [--insecure-skip-tls-verify=true]
```

### Get token
```
token=$(kubectl -n default get secret/absmo-sa-token-<id> -o jsonpath='{.data.token}' | base64 -d)
```

### Set credentials
```
kubectl config set-credentials absmo-dev-b-sa [--client-certificate=path/to/certfile] [--client-key=path/to/keyfile] [--token=$token] [--username=basic_user] [--password=basic_password]
```

### Set context
```
kubectl config set-context absmo-dev-b-context --cluster=absmo-dev-b-cluster --user=absmo-dev-b-sa
```

### Use context
```
kubectl config [--kubeconfig=config-demo] use-context absmo-dev-b-context
```

### View config
```
kubectl config [--kubeconfig=config-demo] view --minify
```

### View context
```
kubectl config current-context
```
