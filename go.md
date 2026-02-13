# go

```
which go
go env GOROOT
go env GOENV
go env GOCACHE
```

## Install
```
go install golang.org/dl/go<semver>@latest
go<semver> download
```

## Uninstall
```
rm -rv $(go env GOROOT)
rm -rv "$(go env GOENV)/*"
```

## Clean
```
go clean -cache
```
