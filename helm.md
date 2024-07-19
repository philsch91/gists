# helm

## version
```
helm version
```

## create
```
helm create <chart-name>
```

## template
```
helm template <chart-name>
```

## package
```
helm package <chart-name>
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
helm dependency update
```

## install
```
helm install <release-name> \
  <repo-name>/<chart-name> | . (=local chart with subchart dependencies) \
  --name=<application-name> \
  -n <namespace-name> | --namespace <namespace-name> \
  --create-namespace \
  -f [<dir>/]values.yaml \
  [--set clusterName=<cluster-name> \]
  [--set ingress.enabled=true \]
  [--set "ingress.hosts[0].host=<app.domain.tld>,ingress.hosts[0].paths[0].path=/" \]
  [--set image.pullPolicy=Always \]
  [--set installCRDs=true \]
  --timeout=10m \
  --debug \
  [--wait --dry-run[=<server|client>] | --atomic]
```

## upgrade
```
helm upgrade -i <release-name> \
  <repo-name>/<chart-name> | . (=local chart with subchart dependencies) \
  -n <namespace-name> | --namespace <namespace-name> \
  --create-namespace \
  -f [<dir>/]values.yaml \
  [--set ingress.enabled=true \]
  [--set "ingress.hosts[0].host=<app.domain.tld>,ingress.hosts[0].paths[0].path=/" \]
  --timeout=10m \
  --debug \
  [--wait --dry-run=<server|client> | --atomic]
```

## list

```
helm list -a
helm list -aq
```

## uninstall

```
helm uninstall <name> -n <namespace> # formerly helm delete <name>
```
