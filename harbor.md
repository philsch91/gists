# Harbor

## api
```
curl -iSs https://<hostname>/api/v2.0/ping
```

## projects
```
# get project_name or project_id
curl -iSs -u "${USER}:${PWD}" -H "Accept: application/json" -X GET "https://${URL}/api/v2.0/projects/<project_name_or_id>"
```

## repositories
```
# list repositories
# check response header X-Total-Count for page size
curl -iSs -u "${USER}:${PWD}" -H "Accept: application/json" -X GET "https://${URL}/api/v2.0/projects/<project_name>/repositories?page=1&page_size=100"
# get repository
curl -iSs -u "${USER}:${PWD}" -H "Accept: application/json" -X GET "https://${URL}/api/v2.0/projects/<project_name>/repositories/<repository_name>"

# ?q=name
curl -iSs -X GET "https://${URL}/api/v2.0/projects/{project}/repositories?q=name%3D~nginx&page_size=100"

# artifacts
curl -iSs -X GET "https://${URL}/api/v2.0/projects/{project}/repositories/at_ubi9_minimal_nginx/artifacts?with_tag=true&page_size=100"
```
