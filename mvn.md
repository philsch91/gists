# Maven

## repository
```
ls $HOME/.m2/repository/
```

## settings
```
${M2_HOME}/conf/settings.xml # global settings
${HOME}/.m2/settings.xml # user settings
```

## compile
```
mvn clean compile
```

## package
```
mvn clean [compile] package
unzip -p target/<artifactId>-<version>.jar META-INF/MANIFEST.MF
```

## install
```
mvn [-X] [dependency:purge-local-repository] clean install <plugin>:<goal/mojo> [-U|--update-snapshots (not releases)] [-f|--file <pom.xml>] [-P <profile>] [-Dproperty1=value1] [-Djavax.net.ssl.trustStore=/path/to/cacerts] [-gs|--global-settings global-settings.xml] [-s|--settings settings.xml]
```

## dependency plugin

### purge-local-repository
```
mvn dependency:purge-local-repository -DmanualInclude=<groupId>:<artifactId>
```
### copy-dependencies
Copy the project dependencies from the repo to an output location defined via <outputDirectory>. The default is ${project.build.directory}/dependency.
```
mvn dependency:copy-dependencies
```

## help plugin
Display the effective POM as an XML for the current build, with the active profiles factored in. If verbose, a comment is added to each XML element describing the origin of the line.
```
mvn help:effective-pom -Dverbose=true
```

Display the calculated settings as an XML for the project, given any profile enhancement and the inheritance of the global settings into the user-level settings.
```
mvn help:effective-settings
```
