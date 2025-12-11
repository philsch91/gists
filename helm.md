# helm

## version
```
helm version
```

## create
```
helm create <chart-name>
```

### Chart .gitignore

```markdown
# .gitignore Helm chart

## Files
*.zip
*.tar.gz
*.tar
*.tgz
*.bak
*.swp
*.swo
*.DS_Store
*.local

### Helm files
### prevent inclusion of files created and dependencies downloaded via 'helm dependency update'
*.tgz
Chart.lock

## IDE
.idea/
.vscode/

## Eclipse
.project
```

## lint
```
helm lint
```

## template
```
helm template <release-name> [[<repo-name>/]<chart-name> | .] [-f values.yaml -f values2.yaml] -n <namespace> [--post-renderer ./path/to/executable|hook.sh(kubectl kustomize <kustomization_dir>) \] --debug [--kube-version v1.25.0]
```

## package
```
# download and extract dependencies in /charts directory
helm package <chart-name>|<directory>|.
```

## repo

### repo index
```
helm repo index <sub-folder-for-index-file/> --url <url-path-for-helm-chart-package>
```

### repo add
```
helm repo add <repo-name> <repo-url | https://charts.external-secrets.io>
helm repo update  // force refresh chart version
helm repo list
```

## registry

Helm repos in OCI-based registries

```yaml
apiVersion: v2
name: helm-chart
description: A Helm chart for Kubernetes
type: application
version: 0.0.1
appVersion: "0.0.1"
# Library dependencies
dependencies:
- name: helm-library
  version: 1.0.0-SNAPSHOT
  repository: "oci://container.registry.io/helm"
```

```
# export HELM_EXPERIMENTAL_OCI=1 (version < 3.8.0)
export HELM_REGISTRY_CONFIG="" # "~/.config/helm/registry/config.json"
helm registry login container.registry.io -u <user-name> -p <password>
helm registry logout container.registry.io
```

## push
```
# upload a chart to a repo in an OCI-based registry
helm push chart-0.1.0.tgz oci://localhost:5000/helm-charts
```

## pull

```
// helm pull [chart URL | repo/chartname] [...] [flags]

// with chartname
helm pull <repo-name>/<chart-name> --version <version | 0.7.0> [--untar] [--untardir . | ./<optional-subdir>]

// with repo URL
helm pull <chart-name> --repo <repo-url | https://charts.external-secrets.io> --version <version | 0.9.11> [--untar] [--untardir . | ./<optional-subdir>]

// with repo in an OCI-based registry
helm pull oci://localhost:5000/helm-charts/chart --version <version | 0.1.0>
```

## dependency
```
# generate Chart.lock, create /charts directory and download dependencies
helm dependency update
# reconstruct chart dependencies and build out charts/ directory from Chart.lock file
# If no Chart.lock file is found, 'helm dependency build' will mirror/call 'helm dependency update'
helm dependency build
```

## install
```
helm install <release-name> [<repo-name>/]<chart-name> | . (=local chart with subchart dependencies) \
  --name=<application-name> \
  -n <namespace> | --namespace <namespace> \
  --create-namespace \
  -f | --values [<dir>/]values.yaml \
  [--set clusterName=<cluster-name> \]
  [--set ingress.enabled=true \]
  [--set "ingress.hosts[0].host=<app.domain.tld>,ingress.hosts[0].paths[0].path=/" \]
  [--set image.pullPolicy=Always \]
  [--set installCRDs=true \]
  [--post-renderer ./path/to/executable|hook.sh(kubectl kustomize <kustomization_dir>) \]
  [--version <chart-version>]
  --timeout=10m \
  --debug \
  [--wait --dry-run[=<server|client>] | --atomic]
```

## upgrade
```
helm upgrade -i <release-name> [<repo-name>/]<chart-name> | . (=local chart with subchart dependencies) \
  -n <namespace> | --namespace <namespace> \
  --create-namespace \
  -f | --values [<dir>/]values.yaml \
  [--set ingress.enabled=true \]
  [--set "ingress.hosts[0].host=<app.domain.tld>,ingress.hosts[0].paths[0].path=/" \]
  [--post-renderer ./path/to/executable|hook.sh(kubectl kustomize <kustomization_dir>) \]
  [--version <chart-version>]
  --timeout=10m \
  --debug \
  [--wait --dry-run=<server|client> | --atomic]
```

## list

```
helm list -a
helm list -aq
```

## get

```
helm [-n <namespace>] get all <release-name>
helm [-n <namespace>] get manifest <release-name>
helm [-n <namespace>] get values <release-name> [--revision <revision>]
```

## uninstall

```
helm uninstall <name> -n <namespace> # formerly helm delete <name>
```

## history
```
helm -n <namespace> history <release>
helm -n <namespace> get values <release> [--revision <revision>] [| grep -A 5 image]
```

## rollback
```
helm [-n <namespace>] rollback <release> <revision>
```

## if
```
{{/*
Helm uses the Go template language, and each condition within an if statement is evaluated independently, which means that the second condition will be evaluated regardless of the first.
In Helm, when using conditions in templates, even if the first condition is false, the second condition is still parsed and evaluated.
*/}}
{{- if and .Values.auth.proxy .Values.auth.proxy.url }}{{/* not working */}}
{{- if and .Values.auth.proxy (default false .Values.auth.proxy.url) }}{{/* not working */}}
{{- if (.Values.auth.proxy).url }}{{/* working */}}
"proxy-url": "{{ .Values.auth.proxy.url }}",
{{- else if and (.Values.auth.proxy).enabled (.Values.general.proxy).proxyURL (.Values.general.proxy).proxyPort }}
"proxy-url": "http://{{ .Values.general.proxy.proxyURL }}:{{ .Values.general.proxy.proxyPort }}",
{{- end }}
```

## Post Rendering

### hook.sh
```
#!/bin/bash
# hook.sh
cat <&0 > <kustomization_dir>/all.yaml
kubectl kustomize <kustomization_dir>
```

## Release Storage Backends
```
export HELM_DRIVER=<secret|configmap|sql> # Helm v3 default = secret
export HELM_DRIVER_SQL_CONNECTION_STRING=postgresql://helm-postgres:5432/helm?user=helm&password=changeme
kubectl get secret --all-namespaces -l "owner=helm"
```
