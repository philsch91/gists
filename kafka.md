# Kafka

## Topics
```
/usr/bin/kafka_2.13-3.7.0/bin/kafka-topics.sh --command-config kafka-sasl-client.properties --list --bootstrap-server <kafka-url>:<kafka-port>
./kafka_2.13-3.7.0/bin/kafka-topics.sh --command-config kafka-sasl-client.properties --describe --topic <topic-name> --bootstrap-server <kafka-url>:<kafka-port>
```

## Consumer Groups
```
# list (get) consumer groups
./kafka_2.13-3.7.0/bin/kafka-consumer-groups.sh --bootstrap-server <kafka-url>:<kafka-port> --list [--state] --command-config kafka-sasl-client.properties
# describe consumer group
./kafka_2.13-3.7.0/bin/kafka-consumer-groups.sh --bootstrap-server <kafka-url>:<kafka-port> --describe --group cg.pro.itmp-azit.t.abs.claimtoberouted.sa.ctr --command-config kafka-sasl-client.properties
```

## kcat
```
curl -Ss http://<hostname>:9644/v1/debug/self_test/status
curl -Ss http://<hostname>:9644/v1/cluster_config
curl -Ss http://<hostname>:9644/public_metrics

# cat kcat.conf
metadata.broker.list=<hostname>:<port>
#security.protocol=SASL_PLAINTEXT
security.protocol=SASL_SSL
sasl.mechanisms=SCRAM-SHA-256
sasl.username=<username>
sasl.password=<password>
enable.ssl.certificate.verification=true
#ssl.endpoint.identification.algorithm=https

kcat -F kcat.conf -L
```
