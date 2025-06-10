# Argo CD

## version
```
argocd version
argocd completion
argocd configure
argocd admin
argocd logout
```

## login
```
argocd login <argocd.hostname> --sso
argocd login <argocd.hostname> --username <username> --password <password>
```

## app
```
argocd app list [| grep -i <search-string>]
argocd app get argocd/<app-name> [--grpc-web]
```
