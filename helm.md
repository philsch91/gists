# helm

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

## pull

```
// helm pull [chart URL | repo/chartname] [...] [flags]

// with chartname
helm pull <repo-name>/<chart-name> --version <version | 0.7.0> [--untar] [--untardir . | ./<optional-subdir>]

// with repo URL
helm pull <chart-name> --repo <repo-url | https://charts.external-secrets.io> --version <version | 0.9.11> [--untar] [--untardir . | ./<optional-subdir>]
```

## dependency
```
helm dependency update
```

## install
```
helm install <chart-name> \
  <repo-name>/<chart-name> \
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
helm upgrade -i <chart-name> \
  <repo-name>/<chart-name> \
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
