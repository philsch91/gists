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
helm -n argocd upgrade argocd oci://ghcr.io/argoproj/argo-helm/argo-cd --version <chart-version(8.6.4)> --values values-8.6.4.yaml --wait --dry-run="server" [--debug]
helm -n argocd upgrade argocd oci://ghcr.io/argoproj/argo-helm/argo-cd --version <chart-version(8.6.4)> --values values-8.6.4.yaml --atomic
```

## version
```
argocd version [--grpc-web] [| grep server]
argocd completion
argocd configure
```

## login
```
argocd login <argocd.hostname> --sso
argocd login <argocd.hostname> --username <username> --password <password>
argocd logout <argocd.hostname|context>
```

## context
```
# get the current settings and connection information
argocd context
```

## account
```
# argocd login <argocd.hostname>
argocd account list
argocd account get --account <username>
argocd account get-user-info
argocd account can-i get|sync applications '<project-name>/<app-name>|*/*' [--server <argocd.hostname>] [--auth-token <auth-jwt>]
# If users are managed as admin user, <current-user-password> should be the current admin password
argocd account update-password \
  --account <name> \
  --current-password <current-user-password> \
  --new-password <new-user-password>
# Argo CD generates token for current user if flag --account is omitted
argocd account generate-token --account <username(tu-cicd)>
argocd account list --server <argocd.hostname> --auth-token <auth-jwt>
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
export ARGOCD_AUTH_TOKEN="auth-jwt"
argocd app list [| grep -i <search-string>]
argocd app get argocd/<app-name> [--grpc-web]
argocd app sync <app-name>
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
argocd repocreds list
## add credentials for accessing multiple repositories with the matching domain or pattern
argocd repocreds add registry.name.tld --username <username> --password <password> --type helm --enable-oci
```

```python
def fnv32a(data: bytes) -> int:
  """
  Compute the FNV-1a (Fowler-Noll-Vo, variant "a") 32-bit hash of a byte string.

  This is a straight re-implementation of Go's hash/fnv package
  (fnv.New32a()), which ArgoCD uses internally to derive deterministic
  Kubernetes Secret names for Repository / RepoCreds objects.

  Algorithm (FNV-1a, 32-bit):
      hash = offset_basis
      for each byte b in data:
          hash = hash XOR b
          hash = (hash * FNV_prime) mod 2**32

  Constants (fixed by the FNV spec for the 32-bit variant):
      offset_basis = 2166136261  (0x811c9dc5)
      FNV_prime    = 16777619    (0x01000193)

  Note the XOR happens BEFORE the multiply on each byte - that's what
  distinguishes "1a" from the older "1" variant (multiply-then-XOR).
  """
  FNV_OFFSET_BASIS_32 = 2166136261
  FNV_PRIME_32 = 16777619

  h = FNV_OFFSET_BASIS_32
  for byte in data:
    h ^= byte
    h = (h * FNV_PRIME_32) & 0xFFFFFFFF  # wrap to 32 bits, like Go's uint32
  return h

prefix = "creds"
repo = "01234.dkr.ecr.eu-central-1.amazonaws.com"
project = ""
digest = fnv32a(repo.encode("utf-8") + project.encode("utf-8"))
secret_name = f"{prefix}-{digest}"
print(f"Derived secret name: {secret_name}")
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  annotations:
    managed-by: argocd.argoproj.io
    reconcile.external-secrets.io/data-hash: cf5e81eb0924f811a703af219be28c97
    expirationTimestamp: "1787775763"
  labels:
    argocd.argoproj.io/secret-type: repo-creds
    app.kubernetes.io/managed-by: external-secrets
  name: creds-3851367438
  namespace: argocd
type: Opaque
immutable: false
data:
  username: QVdT # AWS
  password: abcd # update via CronJob or External Secrets
  url: MDEyMzQuZGtyLmVjci5ldS1jZW50cmFsLTEuYW1hem9uYXdzLmNvbQo= # 01234.dkr.ecr.eu-central-1.amazonaws.com
  type: aGVsbQ== # helm
  enableOCI: dHJ1ZQ== # true
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

## argocd-cm
```
configs:
  cm:
    create: true
    # register account in argocd-cm ConfigMap
    accounts.tu-cicd: apiKey # login, apiKey
  rbac:
    policy.csv: |
      # define permissions with role
      p, role:tu-cicd-role, applications, get, */*, allow
      p, role:tu-cicd-role, applications, sync, <project-name>/<app-name>, allow
      # associate user with role
      g, tu-cicd, role:tu-cicd-role
```

## user-token secret
```
apiVersion: v1
kind: Secret
metadata:
  name: tu-cicd-token
  namespace: argocd
  labels:
    app.kubernetes.io/part-of: argocd
type: Opaque
stringData:
  # valid JWT for account type apiKey
  # password for account type login
  token: "<jwt>"
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

### Automated Sync via UI

The `Refresh` button triggers a retrieval of the sources from Git and a comparison of the rendered manifests with the resources on the cluster. An automated sync is executed if the application is configured with `.spec.syncPolicy.automated.<subkey>: true|false`.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  annotations:
    helm.sh/resource-policy: keep
    argocd.argoproj.io/sync-options: Delete=false,Prune=false
    meta.helm.sh/release-name: app-bootstrap
    meta.helm.sh/release-namespace: argocd
  labels:
    app.kubernetes.io/managed-by: Helm
  name: app-bootstrap
spec:
  syncPolicy:
    automated:
      enabled: true # true by default
      selfHeal: true # false by default
      prune: false # false by default
      allowEmpty: false # false by default
```

## Sync Options

Most of the sync options are configured in the `Application` resource `spec.syncPolicy.syncOptions` attribute. Some sync options can be defined with the `argocd.argoproj.io/sync-options` annotation in a specific resource. Multiple sync options are configured with the `argocd.argoproj.io/sync-options` annotation by concatenation with a `,` in the annotation value, where white-spaces will be trimmed.

### Disable `Prune`

```yaml
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

## AppProject.v1alpha1.argoproj.io

Define `AppProject`s with `helm.sh/resource-policy: keep` and `argocd.argoproj.io/sync-options: Delete=false,Prune=false` in `.metadata.annotations`, and `- resources-finalizer.argocd.argoproj.io` in `.metadata.finalizers` preventing a deletion for any application references.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  annotations:
    helm.sh/resource-policy: keep
    argocd.argoproj.io/sync-options: Delete=false,Prune=false
    meta.helm.sh/release-name: bootstrap-apps-projects
    meta.helm.sh/release-namespace: argocd
  labels:
    app.kubernetes.io/managed-by: Helm
  name: app-peerauthentication
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  description: Project for PeerAuthentication resources
  destinations:
  - namespace: istio-system
    server: https://kubernetes.default.svc
  - namespace: istio-system
    server: https://01234ABCDE.gr7.eu-central-1.eks.amazonaws.com
  clusterResourceWhitelist:
  - group: ""
    kind: Namespace
  - group: ""
    kind: ServiceAccount
  - group: "external-secrets.io"
    kind: ClusterSecretStore
  - group: "karpenter.sh"
    kind: NodePool
  - group: "karpenter.k8s.aws"
    kind: "EC2NodeClass"
  # - group: "*"
  #   kind: "*"
  namespaceResourceWhitelist:
  # kubectl get crd <crd-name> -o jsonpath='{.spec.scope}' # Namespaced
  - group: "networking.k8s.io"
    kind: Ingress
  - group: "apps"
    kind: Deployment
  - group: ""
    kind: ConfigMap
  - group: ""
    kind: Service
  - group: "security.istio.io"
    kind: PeerAuthentication
  # - group: "*"
  #   kind: "*"
  sourceRepos:
  - '*'
```

## Application.v1alpha1.argoproj.io

Define `Application`s with `helm.sh/resource-policy: keep` and `argocd.argoproj.io/sync-options: Delete=false,Prune=false` in `.metadata.annotations`, especially `Application`s creating child `Application`s with the "App of Apps" approach. Define `Application`s with `.spec.syncPolicy.automated.prune: false` and `.spec.syncPolicy.automated.allowEmpty: false`, especially for critical applications, except `Application`s creating child `Application`s with the "App of Apps" approach. Prefer `.spec.syncPolicy.syncOptions.ServerSideApply: true` for resource annotation limit of `kubectl.kubernetes.io/last-applied-configuration`, multiple owners and actors of resource fields, and concurrent management of controllers.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  annotations:
    helm.sh/resource-policy: keep
    argocd.argoproj.io/sync-options: Delete=false,Prune=false
    meta.helm.sh/release-name: app-bootstrap
    meta.helm.sh/release-namespace: argocd
  labels:
    app.kubernetes.io/managed-by: Helm
  name: app-bootstrap
  namespace: argocd
spec:
  destination:
    namespace: argocd
    server: https://kubernetes.default.svc
  project: default
  sources:
  - repoURL: https://<hostname>/argocd-apps-bootstrap.git
    path: .
    targetRevision: main
    helm:
      valueFiles:
        - $values/apps/<app>/values.yaml
  - repoURL: https://<hostname>/argocd.git
    path: .
    targetRevision: main
    ref: values
  syncPolicy:
    automated:
      enabled: true # true by default
      selfHeal: true # false by default
      prune: false # false by default
      allowEmpty: false # false by default
    syncOptions:
    - ServerSideApply=true
    - Prune=false
    - PrunePropagationPolicy=foreground
    - PruneLast=true
    - CreateNamespace=true
```

## Argo CD + Helm

Argo CD uses Helm if a `Chart.yaml` file exists at the location pointed to by `.spec.source.repoURL` and `.spec.source.path`, but only as a template mechanism. It runs `helm template` and then deploys the resulting manifests on the cluster instead of doing `helm install`. Resources can therefore not be viewed or verified with `helm ls`.

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
    syncOptions:
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
