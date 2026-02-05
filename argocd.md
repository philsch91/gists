# Argo CD

## Installation
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.1.1/manifests/install.yaml
helm -n argocd install argocd oci://ghcr.io/argoproj/argo-helm/argo-cd --version <chart-version>

# helm
helm -n argocd get values argocd [| less|>/tmp/argocd/values-argo-cd-<version>.yaml]

## resources definitions in output of `helm get all` are correctly ordered compared to `argocd admin export`
helm -n argocd get all argocd >/tmp/argocd/argo-cd-<version>.yaml
awk '/argocd-cm/,/---/ {print; if ($0 ~ /---/) exit}' /tmp/argocd/argo-cd-8.6.4.yaml | less
awk '/argocd-cmd-params-cm/,/---/ {print; if ($0 ~ /---/) exit}' /tmp/argocd/argo-cd-8.6.4.yaml | less
awk '/argocd-rbac-cm/,/---/ {print; if ($0 ~ /---/) exit}' /tmp/argocd/argo-cd-8.6.4.yaml | less

# kubectl
kubectl -n argocd get cm/argocd-cm [-o yaml | less]
k -n argocd get cm/argocd-cmd-params-cm
k -n argocd get cm/argocd-gpg-keys-cm
k -n argocd get cm/argocd-notifications-cm
k -n argocd get cm/argocd-rbac-cm
k -n argocd get cm/argocd-ssh-known-hosts-cm
k -n argocd get cm/argocd-tls-certs-cm

for cm in $(k -n argocd get cm | grep -i argocd | awk '{print $1}'); do k -n argocd get cm/${cm} -o yaml >/tmp/argocd/${cm}.yaml; done

for scr in $(k -n argocd get secret | grep -i argocd | awk '{print $1}'); do k -n argocd get secret/${scr} -o yaml >/tmp/argocd/${scr}.yaml; done

for cluster_secret in $(k -n argocd get secret -l argocd.argoproj.io/secret-type=cluster | tail -n +2 | awk '{print $1}'); do cluster_values=$(k -n argocd get secret/$cluster_secret -o jsonpath='{.data.name}{"\t"}{.data.server}{"\t"}{.data.config}'); echo "Name: $(echo $cluster_values | awk '{print $1}' | base64 -d)"; echo "Server: $(echo $cluster_values | awk '{print $2}' | base64 -d)"; echo "Config: $(echo $cluster_values | awk '{print $3}' | base64 -d)"; done

# argocd repocreds add registry.name.tld --username <username> --password <password> --type helm --enable-oci
for argo_repo_cred_secret in $(k -n argocd get secret -l argocd.argoproj.io/secret-type=repo-creds | tail -n +2 | awk '{print $1}'); do repo_cred_values=$(k -n argocd get secret/$argo_repo_cred_secret -o jsonpath='{.data.url}{"\t"}{.data.username}{"\t"}{.data.password}{"\t"}{.data.type}{"\t"}{.data.enableOCI}'); echo "URL: $(echo $repo_cred_values | awk '{print $1}' | base64 -d)"; echo "Username: $(echo $repo_cred_values | awk '{print $2}' | base64 -d)"; echo "Password: $(echo $repo_cred_values | awk '{print $3}' | base64 -d)"; echo "Type: $(echo $repo_cred_values | awk '{print $4}' | base64 -d)"; echo "EnableOCI: $(echo $repo_cred_values | awk '{print $5}' | base64 -d)"; done
```

## Upgrade
```
k -n argocd get ingress/argocd-server -o yaml >/tmp/argocd/argocd-server-ingress.yaml
helm -n argocd ls | grep argo-cd
helm -n argocd upgrade argocd oci://ghcr.io/argoproj/argo-helm/argo-cd --version <chart-version(8.6.4)> --values values-8.6.4.yaml --wait --dry-run="server"
helm -n argocd upgrade argocd oci://ghcr.io/argoproj/argo-helm/argo-cd --version <chart-version(8.6.4)> --values values-8.6.4.yaml --atomic
```

## version
```
argocd version [--grpc-web] [| grep server]
argocd completion
argocd configure
argocd logout
```

## account
```
argocd account list
argocd account get --account <username>
# If users are managed as admin user, <current-user-password> should be the current admin password
argocd account update-password \
  --account <name> \
  --current-password <current-user-password> \
  --new-password <new-user-password>
# Argo CD generates token for current user if flag --account is omitted
argocd account generate-token --account <username>
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
argocd admin export >/tmp/argocd-admin-export.yaml
argocd admin import - < /tmp/argocd-admin-export.yaml
# Reset initial admin password
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
argocd admin initial-password reset
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
argocd repo add https://charts.helm.sh/stable --type helm --name stable [--username <username> --password <password>]
# add a private HTTPS OCI repository named 'stable'
argocd repo add oci://helm-oci-registry.name.tld --type oci --name stable --username <username> --password <password> [--insecure-skip-server-verification]
# add a private HTTPS OCI Helm repository named 'stable'
argocd repo add registry.name.tld/<repository>/<chart-repository> --type helm --name stable --username <username> --password <password> --enable-oci
```

## repocreds
```
## add credentials for accessing multiple repositories with the matching domain or pattern
argocd repocreds add registry.name.tld --username <username> --password <password> --type helm --enable-oci
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
k -n argocd get cm/argocd-cmd-params-cm -o json | jq -r '.data["reposerver.disable.tls"]'
k -n argocd get deployment/argocd-repo-server -o json | jq -r '.spec.template.spec.containers[].env[] | select(.name == "ARGOCD_REPO_SERVER_DISABLE_TLS")'
k -n argocd logs pod/argocd-repo-server-76fc47d78d-8tgxh
```

## App of Apps
```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo ls
helm -n argocd upgrade -i bootstrap-apps-projects argo/argocd-apps --values values.projects.yaml
helm -n argocd get all <argocd-application-release>
k -n argocd get appproject
k -n argocd get application
k -n argocd get application/artifactory-dev-cpp-ci-cd-bmp -o json | jq -r '.status.sync'
```

## Automated Sync

An automated sync will only be performed if the application is out of sync. Applications in a synced or error state will not attempt automated sync.

`.spec.syncPolicy.automated(.enabled: true)` in `Application.argoproj.io`
```
k -n argocd get cm/argocd-cm -o json | jq -r '.data["timeout.reconciliation"]'
k -n argocd get sts/argocd-application-controller -o json | jq -r '.spec.template.spec.containers[].env[] | select(.name == "ARGOCD_RECONCILIATION_TIMEOUT")'
```

`.spec.syncPolicy.automated.selfHeal: true` in `Application.argoproj.io`
```
k -n argocd get cm/argocd-cmd-params-cm -o json | jq -r '.data["controller.self.heal.timeout.seconds"]'
k -n argocd get sts/argocd-application-controller -o json | jq -r '.spec.template.spec.containers[].env[] | select(.name == "ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_TIMEOUT_SECONDS")'
```

## Sync Options

Most of the sync options are configured in the `Application` resource `spec.syncPolicy.syncOptions` attribute. Some sync options can be defined with the `argocd.argoproj.io/sync-options` annotation in a specific resource. Multiple sync options are configured with the `argocd.argoproj.io/sync-options` annotation by concatenation with a `,` in the annotation value, where white-spaces will be trimmed.

### Disable `Prune`

```
apiVersion: v1
kind: Namespace
metadata:
  labels:
    name: <namespace-name>
  finalizers:
  - suborg.org.com/finalizer
  annotations:
    argocd.argoproj.io/sync-options: Prune=false
  name: <namespace-name>
```

## Argo CD + Helm

Argo CD uses Helm if a `Chart.yaml` file exists at the location pointed to by `.spec.source.repoURL` and `.spec.source.path`, but only as a template mechanism. It runs `helm template` and then deploys the resulting manifests on the cluster instead of doing `helm install`. Resources can therefore not be viewed or verified with `helm ls`.

## Application.v1alpha1.argoproj.io

Define `Application`s with `.spec.syncPolicy.automated.prune: false` and `.spec.syncPolicy.automated.allowEmpty: false`, especially in combination with `stage: prod`, except `Application`s creating child `Application`s with the "App of Apps" approach.

## Argo CD + Kustomize

If the `kustomization.yaml` file exists at the location pointed to by `.spec.source.repoURL` and `.spec.source.path`, Argo CD will render the manifests using Kustomize.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  annotations:
  labels:
  name: application
  namespace: argocd
spec:
  destination:
    namespace: app-namespace
    server:
  project: app-project
  source:
    repoURL:
    targetRevision: main
    path: apps/app/kustomization/overlays/stage
    kustomize: # optional
      patches:
      - patch: |-
          - op: replace
            path: /metadata/labels/label.name
            value: label-value
        target:
          kind: Namespace
          name: app-namespace
  syncPolicy:
    automated:
      # enabled: true # true by default
      selfHeal: true # false by default
      # prune: false # false by default
      # allowEmpty: false # false by default
    syncOptions:
    - ServerSideApply=true
    - Prune=false
    # - PrunePropagationPolicy=foreground
    # - PruneLast=true
```

## Errors

- Error: `Unable to save changes: application spec is invalid: InvalidSpecError: repository not accessible: repository not found`<br />
  Solution: The deployment.apps/argocd-repo-server is not able to access (read) `.spec.source.repoURL`.

## References

- https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd
- https://github.com/argoproj/argo-helm/tree/main/charts/argocd-apps
- https://github.com/argoproj/argo-cd/tree/master/docs/operator-manual
- https://argo-cd.readthedocs.io/en/stable/operator-manual/
- https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/overview/
- https://argo-cd.readthedocs.io/en/stable/operator-manual/disaster_recovery/
- https://argo-cd.readthedocs.io/en/latest/faq/
