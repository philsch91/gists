# Nexus

## Maven2
```
nexusUrl=https://<base-url>/service/rest/v1/components?repository=<maven2-hosted-repository-name>

curl -Ssv -u <username>:<password> -X POST "$nexusUrl" -F maven2.groupId="<group-id>" -F maven2.artifactId="<artifact-id>" -F maven2.version="<version>" -F maven2.packaging=jar -F maven2.generate-pom=true -F maven2.asset1.extension=jar -F maven2.asset1=@<path-to-jar-file>
```
