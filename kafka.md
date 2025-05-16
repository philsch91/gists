# Kafka

## Topics
```
/usr/bin/kafka_2.13-3.7.0/bin/kafka-topics.sh --command-config kafka-sasl-client.properties --list --bootstrap-server <kafka-url>:<kafka-port>
./kafka_2.13-3.7.0/bin/kafka-topics.sh --command-config kafka-sasl-client.properties --describe --topic <topic-name> --bootstrap-server <kafka-url>:<kafka-port>
```

## Consumer Groups
```
# list (get) consumer groups
./kafka_2.13-3.7.0/bin/kafka-consumer-groups.sh --bootstrap-server <kafka-url>:<kafka-port> --list --command-config kafka-sasl-client.properties
# describe consumer group
./kafka_2.13-3.7.0/bin/kafka-consumer-groups.sh --bootstrap-server <kafka-url>:<kafka-port> --describe --group cg.pro.itmp-azit.t.abs.claimtoberouted.sa.ctr --command-config kafka-sasl-client.properties
```
