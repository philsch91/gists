# Maven

## repository
```
lla $HOME/.m2/repository/
```

## package
```
mvn clean package
```

## install
```
mvn [-X] [dependency:purge-local-repository] clean install <plugin>:<goal/mojo> [-U|--update-snapshots (not releases)] [-f|--file <pom.xml>] [-P <profile>] [-Dproperty1=value1] [-Djavax.net.ssl.trustStore=/path/to/cacerts] [-s|--settings settings.xml]
```

## dependency plugin

### purge-local-repository
```
mvn dependency:purge-local-repository -DmanualInclude=<groupId>:<artifactId>
```
