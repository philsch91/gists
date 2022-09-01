# GitHub

## Organizations

curl -iSs -X GET -u <username>:<token> -H "Accept: application/vnd.github+json" https://github.company.com/api/v3/orgs/<organization>/repos

## Repositories

curl -iSs -X GET -u <username>:<token> -H "Accept: application/vnd.github+json" https://github.company.com/api/v3/repos/<organization>/<repo>
