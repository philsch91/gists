# Argo CD

## Installation
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.1.1/manifests/install.yaml
helm -n argocd install argocd oci://ghcr.io/argoproj/argo-helm/argo-cd --version <chart-version>

kubectl -n argocd get cm/argocd-cm
k -n argocd get cm/argocd-cmd-params-cm
k -n argocd get cm/argocd-gpg-keys-cm -o yaml | less
k -n argocd get cm/argocd-notifications-cm
k -n argocd get cm/argocd-rbac-cm -o yaml | less
k -n argocd get cm/argocd-ssh-known-hosts-cm -o yaml | less
k -n argocd get cm/argocd-tls-certs-cm -o yaml | less

for cm in $(k -n argocd get cm | grep -i argocd | awk '{print $1}'); do k -n argocd get cm/${cm} -o yaml >/tmp/argocd/${cm}.yaml; done
for scr in $(k -n argocd get secret | grep -i argocd | awk '{print $1}'); do k -n argocd get secret/${scr} -o yaml >/tmp/argocd/${scr}.yaml; done
```

## version
```
argocd version [--grpc-web] [| grep server]
argocd completion
argocd configure
argocd logout
```

## login
```
argocd login <argocd.hostname> --sso
argocd login <argocd.hostname> --username <username> --password <password>
```

## context
Get the current settings and connection information
```
argocd context
```

## admin
```
argocd admin
argocd admin export >/tmp/argocd-backup.yaml
argocd admin import - < /tmp/argocd-backup.yaml
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

## repo
```
argocd repo list
```

## argocd-server
```
k -n argocd get deployment/argocd-server -o yaml
```

## argocd-redis
```
k -n argocd get deployment/argocd-redis -o yaml
```

## argocd-repo-server
```
k -n argocd get deployment/argocd-repo-server -o yaml
k -n argocd logs pod/argocd-repo-server-76fc47d78d-8tgxh
```

## App of Apps
```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo ls
helm -n argocd upgrade -i bootstrap-apps-projects argo/argocd-apps --values values.projects.yaml
helm -n argocd get all <argocd-application-release>
k -n argocd get appprojects
k -n argocd get applications
```

## References

- https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd
- https://github.com/argoproj/argo-helm/tree/main/charts/argocd-apps
- https://github.com/argoproj/argo-cd/tree/master/docs/operator-manual
- https://argo-cd.readthedocs.io/en/stable/operator-manual/
- https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/overview/
- https://argo-cd.readthedocs.io/en/stable/operator-manual/disaster_recovery/
