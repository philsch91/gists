# helm

## repo

### repo add
```
helm repo add <repo-name> <repo-url | https://charts.external-secrets.io>
```

## pull

```
// helm pull [chart URL | repo/chartname] [...] [flags]

// with chartname
helm pull <repo-name>/<chart-name> --version <version | 0.7.0> [--untar] [--untardir . | ./<optional-subdir>]

// with repo URL
helm pull <chart-name> --repo <repo-url | https://charts.external-secrets.io> --version <version | 0.9.11> [--untar] [--untardir . | ./<optional-subdir>]
```

## install
```
helm install <name> \
  <repo-name>/<chart-name> \
  --namespace <namespace | name> \
  --create-namespace \
  --set installCRDs=true
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
