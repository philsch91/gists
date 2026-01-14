# Nexus

## `GET /repository/<repo-name>`

Downloads artifact from remote repo to proxy repo
```
curl -X GET https://<base-url>/repository/<repo-name>/<groupId1>/<groupId2>/<artifactId>/<version>/<artifactId>-<version>.jar
```

## `GET /service/rest/v1/search/assets`

With `-G` without `-X GET`: HTTP 200<br />
With `-X GET` without `-G`: HTTP 415<br />
Without `-X GET -G`: HTTP 405

```
curl -iSsL [-X GET] -G https://<base-url>/service/rest/v1/search/assets -d repository=maven-central -d maven.groupId=org.jsoup -d maven.artifactId=jsoup -d maven.baseVersion=1.13.1 -d maven.extension=jar [-d maven.classifier=jar-with-dependencies]
```

## `GET /service/rest/v1/components`
```
curl -iSs -X GET "https://<base-url>/service/rest/v1/components?repository=<repo-name>" | jq -r '.items[].assets[].downloadUrl'
```

## `POST /service/rest/v1/components`
```
# Hosted Maven2 repo upload
nexusUrl=https://<base-url>/service/rest/v1/components?repository=<maven2-hosted-repository-name>

curl -Ssv -u <username>:<password> -X POST "$nexusUrl" -F maven2.groupId="<group-id>" -F maven2.artifactId="<artifact-id>" -F maven2.version="<version>" -F maven2.packaging=jar -F maven2.generate-pom=true -F maven2.asset1.extension=jar -F maven2.asset1=@<path-to-jar-file>
```
