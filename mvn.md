# Maven

## Files
```
ls $HOME/.m2/repository/
ls -lah /home/<username>/.m2/repository/<groupId1>/<groupId2>/<groupId3>/*

## settings
${M2_HOME|MAVEN_HOME}/conf/settings.xml # global settings
${HOME}/.m2/settings.xml # user settings
```

### pom.xml
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">

  <modelVersion>4.0.0</modelVersion>

  <groupId></groupId>
  <artifactId></artifactId>
  <version>${revision}</version>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <revision></revision>
  </properties>

  <repositories>
    <repository>
      <id>nexus-releases</id>
      <url>https://nexus.org.tld/repository/releases</url>
    </repository>
  </repositories>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId></groupId>
        <artifactId></artifactId>
        <version></version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <dependencies>
    <dependency>
      <groupId></groupId>
      <artifactId></artifactId>
      <scope></scope>
    </dependency>
  </dependencies>
</project>
```

### settings.xml
```
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                    https://maven.apache.org/xsd/settings-1.0.0.xsd">
    <localRepository/>
    <interactiveMode/>
    <offline/>
    <pluginGroups/>
    <servers>
        <!-- needed (only) if repo.user and repo.password are needed and set -->
        <server>
            <!-- server id in settings.xml must match repository id in pom.xml -->
            <id>nexus-releases</id>
            <!-- -Dnexus.repo.user=<username> -Dnexus.repo.password=<password> -->
            <!--
            <username>${nexus.repo.user}</username>
            <password>${nexus.repo.password}</password>
            -->
            <!-- set as export REPO_USER=<username> and export REPO_PWD=<password> -->
            <!--
            <username>${env.REPO_USER}</username>
            <password>${env.REPO_PWD}</password>
            -->
        </server>
    </servers>
    <mirrors/>
    <proxies>
        <proxy>
            <!--<id>company-proxy</id>-->
            <active>true</active>
            <protocol>http</protocol>
            <!--<host>proxy.company.com:8080/proxy_pac</host>-->
            <host>proxy.company.com</host>
            <port>8080</port>
            <!--<username></username>-->
            <!--<password></password>-->
            <nonProxyHosts>*.local.net|*.company.com|some.host.com|www.google.com</nonProxyHosts>
        </proxy>
      </proxies>
    <profiles>
        <profile>
            <id>nexus</id>
            <repositories>
                <repository>
                    <id>central</id>
                    <url>https://nexus.devops-services.cloud.company.com/repository/central/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </repository>
            </repositories>
        </profile>
    </profiles>
    <activeProfiles>
        <activeProfile>nexus</activeProfile>
    </activeProfiles>
</settings>
```

## Variables
```
# Maven >= 3.9.0
export MAVEN_ARGS="-s /path/to/settings.xml"
export MAVEN_OPTS="-Dmaven.settings=/path/to/settings.xml"
```

## phases
```
validate -> generate-sources -> process-resources -> compile -> test -> package -> verify -> install -> deploy
```

## compile
```
mvn clean compile
```

## test
```
mvn -Dtest=<package-1.package-2>.<test-class-name>#<method-name> -D<prop-name-1.prop-name-2>=<prop-value> test
```

## package
```
# runs phases up to package, including generate-sources -> compile -> package
mvn clean [compile] [-DskipTests] package
unzip -p target/<artifactId>-<version>.jar META-INF/MANIFEST.MF
```

## install
```
mvn [-X] [dependency:purge-local-repository] clean install <plugin>:<goal/mojo> [-U|--update-snapshots (not releases)] [-f|--file <pom.xml>] [-P <profile>] [-Dproperty1=value1] [-Djavax.net.ssl.trustStore=/path/to/cacerts] [-gs|--global-settings global-settings.xml] [-s|--settings settings.xml]
```

## Manual uninstall
```
rm -rv /home/<username>/.m2/repository/<groupId1>/<groupId2>/<groupId3>/<artifactId>/<version>
```

## dependency plugin

### dependency:tree
```
mvn dependency:tree -Ddetail=true
```

### dependency:sources
```
mvn dependency:sources [-f /path/to/pom.xml]
```

### dependency:purge-local-repository
```
mvn dependency:purge-local-repository -DmanualInclude=<groupId>:<artifactId>
```
### dependency:copy-dependencies
Copy the project dependencies from the repo to an output location defined via <outputDirectory>. The default is ${project.build.directory}/dependency.
```
mvn dependency:copy-dependencies
```

### dependency:get
```
mvn dependency:get -Dartifact=<groupId>:<artifactId>:<version> -o -DrepoUrl=file:///home/<username>/.m2/repository
```

### dependency:resolve-plugins

Goal that resolves all project plugins and reports and their dependencies.
```
mvn dependency:resolve-plugins
```

## help plugin

### help:effective-pom

Display the effective POM as an XML for the current build, with the active profiles factored in. If verbose, a comment is added to each XML element describing the origin of the line.
```
mvn help:effective-pom -Dverbose=true
```

### help:effective-settings

Display the calculated settings as an XML for the project, given any profile enhancement and the inheritance of the global settings into the user-level settings.
```
mvn help:effective-settings
```

### help:evaluate
```
# Maven 3.9.x
mvn help:evaluate -Dexpression=project.version -q -DforceStdout [-f path/to/pom.xml]
# Maven 4.0.x
mvn help:evaluate -Dexpression=project.version --raw-streams -q -DforceStdout [-f path/to/pom.xml]
```

## org.codehaus.mojo.versions-maven-plugin
```
mvn versions:help
mvn versions:set-property -Dproperty=some-key -DnewVersion=some-value -DgenerateBackupPoms=false
```
