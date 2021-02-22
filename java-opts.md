Kubernetes Container Settings

`-XX:+UseContainerSupport -XX:InitialRAMPercentage=50 -XX:MinRAMPercentage=25 -XX:MaxRAMPercentage=80 -XX:NewRatio=4 -XX:SurvivorRatio=4`

`JAVA_OPTS="${JAVA_OPTS} -XX:+UseContainerSupport -XX:InitialRAMPercentage=50 -XX:MinRAMPercentage=25 -XX:MaxRAMPercentage=80 -XX:NewRatio=4 -XX:SurvivorRatio=4"`

Explicity enable G1GC and disable Mark Sweep Compact

`-XX:+UseG1GC -XX:-UseConcMarkSweepGC -XX:-UseCMSInitiatingOccupancyOnly`

Debug Memory

`-XX: NativeMemoryTracking`

Debugging

`-Xdebug -agentlib:jdwp=transport=dt_socket,address=8300,server=y,suspend=n`
