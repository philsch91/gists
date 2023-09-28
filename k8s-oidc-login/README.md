# K8s OIDC Login

[set-k8s-oidc-kubectl-config.sh](https://github.com/philsch91/scripts/blob/main/set-k8s-oidc-kubectl-config.sh)

## Installation and Setup
1. Download kubelogin binary
2. Move kubelogin into same directory as kubectl (optional)
3. Create a symbolic link `kubectl-oidc_login` pointing to kubelogin
4. Add the directory containing the `kubectl-oidc_login` symlink to the $PATH environment variable
5. Test plugin installation via `kubectl oidc-login`
6. `kubectl oidc-login setup --oidc-issuer-url https://saml.company.com/oauth/ --oidc-client-id <oidc-client-id> --oidc-client-secret <oidc-client-secret> --oidc-extra-scope groups,email`

## Set Credentials
```
kubectl config set-credentials <oidc-client-id>-credentials \
  --exec-api-version=client.authentication.k8s.io/v1beta1 \
  --exec-command=kubectl \
  --exec-arg=oidc-login \
  --exec-arg=get-token \
  --exec-arg=--oidc-issuer-url=https://saml.company.com/oauth/ \
  --exec-arg=--oidc-client-id=<oidc-client-id> \
  --exec-arg=--oidc-client-secret=<oidc-client-secret> \
  --exec-arg=--oidc-extra-scope=groups \
  --exec-arg=--oidc-extra-scope=email
```

## Set Cluster
```
kubectl config set-cluster <cluster-name>-cluster --server=https://<host>:<port> --embed-certs --certificate-authority=<path-to/cluster-ca.pem> [--insecure-skip-tls-verify=true]
```

## Set Context
```
kubectl config set-context <cluster-name>-<oidc-client-id>-context --cluster=<cluster-name>-cluster --user=<oidc-client-id>-credentials
```

## Use Context
```
kubectl config [--kubeconfig=config-demo] use-context <cluster-name>-<oidc-client-id>-context
```

## View Config
```
kubectl config [--kubeconfig=config-demo] view --minify
```

## View Context
```
kubectl config current-context
```
