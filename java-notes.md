# Java Notes

## JVM Settings

- `java -X` will return a list of all -X options

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

`-XX: NativeMemoryTracking`

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
- `-XX:+UseContainerSupport` is enabled by default<br />
- `-XX:MaxRAMPercentage` does not recognize integer value and must be floating point value (float) [JDK-8219312](https://bugs.java.com/bugdatabase/view_bug.do?bug_id=8219312)<br />

```
// -XX:MinRAMPercentage and -XX:MaxRAMPercentage should be used together
-XX:+UseContainerSupport -XX:InitialRAMPercentage=50.0 -XX:MinRAMPercentage=25.0 -XX:MaxRAMPercentage=80.0
-XX:+UseContainerSupport -XX:InitialRAMPercentage=75.0 -XX:MinRAMPercentage=25.0 -XX:MaxRAMPercentage=75.0
```

```
JAVA_OPTS="${JAVA_OPTS} -XX:+UseContainerSupport -XX:InitialRAMPercentage=50 -XX:MinRAMPercentage=25 -XX:MaxRAMPercentage=80 -XX:NewRatio=4 -XX:SurvivorRatio=4 -javaagent:/srv/jolokia-jvm-1.6.2-agent.jar=port=8778,host=0.0.0.0,user=jolokia,password=jolokia,policyLocation=classpath:/srv/jolokia/jolokia-access.xml -javaagent:/srv/prometheus/jmx_prometheus_javaagent-0.15.0.jar=9081:/srv/conf/prometheus/app.yml"
java -jar app.jar ${JAVA_OPTS}
```

## jcmd

```
jcmd <pid> <command>
jcmd 1234 VM.flags
```
