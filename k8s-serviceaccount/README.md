# K8s Service Account Access

### Create serviceaccount and clusterrolebinding
```
kubectl -n default apply -f serviceaccount.yaml
kubectl -n default apply -f serviceaccount-clusterrolebinding.yaml
kubectl -n default apply -f serviceaccount-token.yaml
```

### Create serviceaccount with role and rolebinding
```
kubectl apply -f serviceaccount2.yaml
kubectl apply -f serviceaccount2-role.yaml
kubectl apply -f serviceaccount2-rolebinding.yaml
```

### Set cluster
```
kubectl config set-cluster <cluster_name> --server=https://<host>:<port> [--insecure-skip-tls-verify=true|--embed-certs --certificate-authority=path-to/cluster-ca.pem]
```

### Get token
```
token=$(kubectl -n default get secret/absmo-sa-token-<id> -o jsonpath='{.data.token}' | base64 -d)
```

### Set credentials
```
kubectl config set-credentials absmo-dev-b-sa [--client-certificate=path/to/certfile] [--client-key=path/to/keyfile] [--token=$token] [--username=basic_user --password=basic_password]
```

### Set context
```
kubectl config set-context <cluster_name>-context --cluster=<cluster_name> --user=absmo-dev-b-sa
```

### Use context
```
kubectl config [--kubeconfig=config-demo] use-context <cluster_name>-context
```

### View config
```
kubectl config [--kubeconfig=config-demo] view --minify
```

### View context
```
kubectl config current-context
```
