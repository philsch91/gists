# Azure CLI

## General
```
az --version
```

## account
```
az account set --subscription <subscription>
```

## aks
```
az aks get-credentials --overwrite-existing --resource-group <rg-name> --name <aksname>

kubectl -n <namespace> get secret <secretname> -o json|jq '.data|map_values(@base64d)'
```

## Service Principal Creation for ACR
```
az ad sp create-for-rbac --name <sp-name> --role AcrPush --scope /subscriptions/<subscription>/resourceGroups/<rg-name>/providers/Microsoft.ContainerRegistry/registries/<registry-name>
```
