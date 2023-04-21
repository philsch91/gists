# Java

## JVM Settings

- `java -X` will return a list of all -X options

### Networking and Proxies

Linux and macOS
```
JAVA_OPTS=-Dhttp.proxyHost=<proxy-dns-name-or-ip> -Dhttp.proxyPort=8080 -Dhttps.proxyHost=<proxy-dns-name-or-ip> -Dhttps.proxyPort=8080 -Dhttp.nonProxyHosts="localhost|127.0.0.1|10.*.*.*|*.company.com‌​|etc"
echo $JAVA_OPTS
```

Windows
```
set JAVA_OPTS=-Dhttp.proxyHost=<proxy-dns-name-or-ip> -Dhttp.proxyPort=8080 -Dhttps.proxyHost=<proxy-dns-name-or-ip> -Dhttps.proxyPort=8080 -Dhttp.nonProxyHosts="localhost|127.0.0.1|10.*.*.*|*.company.com‌​|etc"
echo %JAVA_OPTS%
```

### Heap Size Settings

Memory = Stack + Heap + Metaspace<br />
-Xms = -XX:InitialHeapSize<br />
-Xmx = -XX:MaxHeapSize<br />

```
java -Xms1024m -Xmx2048m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m
java -Xms4g -Xmx16g -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m
```

### Print JVM Flags

MaxHeapSize = Memory / MaxRAMPercentage<br />
MaxRamPercentage = Heap Size Percentage<br />

```
java -XX:+PrintFlagsFinal -version
java -XX:+PrintFlagsFinal -version | grep -i MaxRAM
java -XX:+PrintFlagsFinal -version | grep -i HeapSize
java -XX:+PrintFlagsFinal -version | grep -i 'MaxHeapSize\|MaxRAMPercentage\|InitialHeapSize\|InitialRAMPercentage'
```

### Garbage Collection Settings

#### Explicity enable G1GC and disable Mark Sweep Compact

```
-XX:+UseG1GC -XX:-UseConcMarkSweepGC -XX:-UseCMSInitiatingOccupancyOnly
```

#### Explicitly enable SerialGC

SerialGC is automatically set in a container that can use <= 1 core

```
-XX:+UseSerialGC
```

#### NewRatio and SurvivorRatio

- `-XX:NewRatio` is the ratio of old generation to young generation
- `-XX:NewRatio=2` means that the max size of the old generation can be at max twice the size of young generation
- `-XX:NewRatio=2` young generation can get up to 1/3 of the heap size

```
-XX:NewRatio=4 -XX:SurvivorRatio=4
```

### Debug Memory

```
-XX: NativeMemoryTracking
```

### Debugging

`-Xdebug -agentlib:jdwp=transport=dt_socket,address=8300,server=y,suspend=n`

### cgroup Memory Settings

- `-XX:+UseCGroupMemoryLimitForHeap` supported in Java 9/8u131<br />
- `-XX:+UseCGroupMemoryLimitForHeap` sets `-XX:MaxRAM` to the cgroup memory limit<br />
- `-XX:MaxRAMFraction=1` might result in killed containers due to OOM errors<br />

MaxRAM = UseCGroupMemoryLimitForHeap<br />
MaxRAMFraction default = 4<br />
Heap size = MaxRAM / MaxRAMFraction<br />

```
-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 [-XX:MinRAMFraction=2]
```

### Kubernetes Container Settings

- `-XX:+UseContainerSupport` supported in Java 10 and backported to Java 8u191<br />
- Java 10 deprecates `-XX:+UseCGroupMemoryLimitForHeap` and introduces `-XX:+UseContainerSupport`, which supersedes it.<br />
- Approved JDK CSR for `-XX:InitialRAMPercentage`, `-XX:MinRAMPercentage` and `-XX:MaxRAMPercentage` [JDK-8186315](https://bugs.openjdk.java.net/browse/JDK-8186315)<br />
- `-XX:+UseContainerSupport` is enabled by default<br />
- `-XX:MaxRAMPercentage` does not recognize integer value and must be floating point value (float) [JDK-8219312](https://bugs.java.com/bugdatabase/view_bug.do?bug_id=8219312)<br />

```
// -XX:MinRAMPercentage and -XX:MaxRAMPercentage should be used together
-XX:+UseContainerSupport -XX:InitialRAMPercentage=50.0 -XX:MinRAMPercentage=25.0 -XX:MaxRAMPercentage=80.0
-XX:+UseContainerSupport -XX:InitialRAMPercentage=75.0 -XX:MinRAMPercentage=25.0 -XX:MaxRAMPercentage=75.0
```

```
// -XX:MinHeapFreeRatio and -XX:MaxHeapFreeRatio must be integer value
-XX:+UseContainerSupport -XX:MinHeapFreeRatio=40 -XX:MaxHeapFreeRatio=70
```

```
JAVA_OPTS="${JAVA_OPTS} -XX:+UseContainerSupport -XX:InitialRAMPercentage=50 -XX:MinRAMPercentage=25 -XX:MaxRAMPercentage=80 -XX:MinHeapFreeRatio=40 -XX:MaxHeapFreeRatio=70 -XX:NewRatio=4 -XX:SurvivorRatio=4 -javaagent:/srv/jolokia-jvm-1.6.2-agent.jar=port=8778,host=0.0.0.0,user=jolokia,password=jolokia,policyLocation=classpath:/srv/jolokia/jolokia-access.xml -javaagent:/srv/prometheus/jmx_prometheus_javaagent-0.15.0.jar=9081:/srv/conf/prometheus/app.yml"
java -jar app.jar ${JAVA_OPTS}
```

### Java Management Extensions (JMX)

```
java -jar app.jar -Dcom.sun.management.jmxremote.port=4447 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.ssl=false
```

## jcmd

```
jcmd <pid> <command>
jcmd 1234 VM.flags
```

## jmap

```
// Get Heap configuration
jmap -heap <pid>
// Cannot connect to core dump or remote debug server. Use jhsdb jmap instead
jhsdb jmap --heap --pid <pid>
```

## jinfo

```
// Get used architecture
jinfo -sysprops <pid> | grep sun.arch.data.model
```

## jconsole
```
jconsole localhost:4447
```

## cmdline-jmxclient
```
java -jar cmdline-jmxclient-0.10.3.jar <user>:<password> <host>:<port> <bean> [<command>]
java -jar cmdline-jmxclient-0.10.3.jar -:- localhost:4447 org.opin.framework:type=statistics,name=A3kSession,id=Rap Sessions
```

## keytool
```
// import single PEM certificate
// and create keystore if needed
keytool -import|-importcert -alias <alias> -file <cert.pem|cert.cer> -keystore keystore.jks -storepass <password>
// import cert chain into truststore
echo "yes" | keytool -import -alias <alias> -keystore cacerts -file <rootcert.pem|rootcert.cer> --storepass <password>

// convert PEM file with SSL certificate trust chain
// or private key and certificate for mutual SSL authentication to DER file
openssl x509 -outform der -in <pem-file> -out <der-file>
//
// import DER certificate
// and create keystore if needed
keytool -import -alias <alias> -file <cert.der> -keystore keystore.jks -storepass <password>

// list keystore entries
keytool -list -v -keystore keystore.jks -storepass <password>

// change keystore password
keytool -storepasswd -keystore keystore.jks

// convert Java keystore to PKCS12 file
keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.jks -deststoretype pkcs12

// copy an entry from one keystore to another
keytool -importkeystore -srckeystore srckeystore.jks -srcstorepass <src-password> -srcalias <src-alias> -destkeystore destkeystore.jks -deststorepass <dest-password>

// convert PKCS12 file to Java keystore
// import private key and certificates from PKCS12 file into Java keystore
// If the pfx does not contain a password, the keytool will crash with a NullPointerException.
keytool -importkeystore -srckeystore <certname.pfx|certname.p12> -srcstoretype pkcs12 -srcstorepass <src-password> -srcalias <src-alias|certname> -destkeystore keystore.jks -deststorepass <dest-password> -deststoretype jks -destalias <dest-alias|certname>

// change password of a key entry
// set password for private key
keytool -keypasswd -keystore keystore.jks -storepass <store-password> -alias <alias-name> -new <new-password> -keypass <old-password>

// change key password of an entry
keytool -list -keystore keystore.jks -storepass <store-password> -alias <alias-name> -keypasswd <>
```
