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
az account get-access-token --resource https://graph.microsoft.com
```

## aks
```
az aks get-credentials --overwrite-existing --resource-group <rg-name> --name <aksname>

kubectl -n <namespace> get secret <secretname> -o json|jq '.data|map_values(@base64d)'
```

## acr
```
az acr show --name <name> [--query 'id']
az role assignment list --role Owner --scope $(az acr show --name <name> --query 'id' | sed "s/\"//g")
```

## ad user
```
az ad user show --id "firstname.surname@org.tld"
```

## ad app
```
az ad app show --id <guid>
az ad app list --display-name <displayName>
az ad app owner list --id <app-id>
ownerId=$(az ad user show --id "firstname.surname@org.tld" | jq -r '.id')
az ad app owner add --id <app-id> --owner-object-id $ownerId
az ad app credential reset --id <app-id> --end-date 2034-06-30
```

## ad sp
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
ownerId=$(az ad user show --id "firstname.surname@org.tld" | jq -r '.id')
az ad sp owner add --id <id or appId> --owner-object-id $ownerId
az ad sp credential list --id <id or appId> [--query '[].endDateTime'] // only owners
az ad sp credential reset --id <appId> --end-date <Y-m-d>
```

Service Principal Creation for ACR
```
az ad sp create-for-rbac --name <sp-name> --role AcrPush --scope /subscriptions/<subscription>/resourceGroups/<rg-name>/providers/Microsoft.ContainerRegistry/registries/<registry-name>
az ad sp create-for-rbac --name <sp-name> --role AcrPull --scope /subscriptions/<subscription>/resourceGroups/<rg-name>/providers/Microsoft.ContainerRegistry/registries/<registry-name>
```

## ad group
```
az ad group list --filter "startswith(displayName,'<group-name-prefix>')"
az ad group list --query "[?displayName=='<group-name>'].objectId" --output tsv
az ad group member list --group <group-object-id> --query "[].displayName"
```

```
token=$(az account get-access-token --resource https://graph.microsoft.com | jq -r '.accessToken')

curl -X POST \
  https://graph.microsoft.com/v1.0/servicePrincipals/<sp-id>/owners/$ref \
  -H "Authorization: Bearer ${token}" \
  -H "Content-Type: application/json" \
  -d '{"@odata.id": "https://graph.microsoft.com/v1.0/directoryObjects/<new-owner-obj-id>"}'
```
