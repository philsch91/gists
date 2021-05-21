# Java Notes

## JVM Settings

Memory = Stack + Heap + Metaspace<br />
-Xms = -XX:InitialHeapSize<br />
-Xmx = -XX:MaxHeapSize<br />

```
java -Xms1024m -Xmx2048m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m
```

### Print JVM Flags

MaxHeapSize = Memory / MaxRAMPercentage<br />
MaxRamPercentage = Heap Size Percentage<br />

```
java -XX:+PrintFlagsFinal -version
java -XX:+PrintFlagsFinal -version | grep 'MaxHeapSize\|MaxRAMPercentage\|InitialHeapSize\|InitialRAMPercentage'
```

### Explicity enable G1GC and disable Mark Sweep Compact

```
-XX:+UseG1GC -XX:-UseConcMarkSweepGC -XX:-UseCMSInitiatingOccupancyOnly
```

### Explicitly enable SerialGC

SerialGC is automatically set in a container that can use <= 1 core

```
-XX:+UseSerialGC
```

### Debug Memory

`-XX: NativeMemoryTracking`

### Debugging

`-Xdebug -agentlib:jdwp=transport=dt_socket,address=8300,server=y,suspend=n`

## Kubernetes Container Settings

```
-XX:+UseContainerSupport -XX:InitialRAMPercentage=50 -XX:MinRAMPercentage=25 -XX:MaxRAMPercentage=80 -XX:NewRatio=4 -XX:SurvivorRatio=4
-XX:+UseContainerSupport -XX:InitialRAMPercentage=75 -XX:MinRAMPercentage=25 -XX:MaxRAMPercentage=75 -XX:NewRatio=4 -XX:SurvivorRatio=4
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
