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

## cluster
Add and remove cluster connected via kubectl in ArgoCD connected via argocd
```
argocd cluster add <context-name (k config current-context)> --name <cluster-name> -y --insecure
argocd cluster rm <context-name>
argocd cluster list
```

## app
```
argocd app list [| grep -i <search-string>]
argocd app get argocd/<app-name> [--grpc-web]
```

```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo ls
helm -n argocd upgrade -i bootstrap-apps-projects argo/argocd-apps --values values.projects.yaml
```

## References

- https://github.com/argoproj/argo-helm/tree/main/charts/argocd-apps
- https://github.com/argoproj/argo-cd/tree/master/docs/operator-manual
