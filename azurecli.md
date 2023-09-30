# Azure CLI

## General
```
az --version
```
## login
```
az login --scope https://graph.windows.net//.default
```

## account
```
az account show # get current session context
az account set --subscription <subscription>
```

## aks
```
az aks get-credentials --overwrite-existing --resource-group <rg-name> --name <aksname>

kubectl -n <namespace> get secret <secretname> -o json|jq '.data|map_values(@base64d)'
```

## AD APP
```
az ad app show --id <guid>
az ad app list --display-name <displayName>
```

## AD SP
```
az ad sp show --id <guid>
az ad sp list
az ad sp list --filter "displayName eq '<sp-name>-acr-pull'"
az ad sp list --query "[?contains(displayName,'<sp-name>-acr-push')]"
az ad sp list --display-name <displayName> --query '[].id'
az ad sp show --id <id or appId> // get .appId
az ad sp list --display-name <displayName> --query '[].appId'
az ad sp list --filter "appId eq '<appId>'"
az ad sp owner list --id <id or appId> [--query '[].displayName']
az ad sp credential list --id <id or appId> [--query '[].endDateTime'] // only owners
az ad sp credential reset --id <appId> --end-date <Y-m-d>
```

Service Principal Creation for ACR
```
az ad sp create-for-rbac --name <sp-name> --role AcrPush --scope /subscriptions/<subscription>/resourceGroups/<rg-name>/providers/Microsoft.ContainerRegistry/registries/<registry-name>
az ad sp create-for-rbac --name <sp-name> --role AcrPull --scope /subscriptions/<subscription>/resourceGroups/<rg-name>/providers/Microsoft.ContainerRegistry/registries/<registry-name>
```
