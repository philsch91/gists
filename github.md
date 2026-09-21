# GitHub

## Organizations
```
# get id, repos_url, events_url, hooks_url, issues_url, members_url, description, name, disk_usage, plan
curl -Ss https://<username>:<token>@<github-hostname>/api/v3/orgs/<org-name>

curl -iSs -X GET -u <username>:<token> -H "Accept: application/vnd.github+json" https://github.company.com/api/v3/orgs/<org-name>/repos
```

## Repositories
```
curl -iSs -X GET -u <username>:<token> -H "Accept: application/vnd.github+json" https://github.company.com/api/v3/repos/<org-name>/<repo-name>
```
