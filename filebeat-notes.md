# Filebeat Notes

## filebeat.yml logstash example
```
filebeat.inputs:
- type: log
  paths:
    - '/var/opt/allianz/logs/*.log'
output:
  logstash:
    hosts: ['<ip>:<port>']
    bulk_max_size: 16
    pipelining: 1
```

## filebeat.yml elasticsearch example

#### adapt elasticsearch.yml
`network.host: <ip>`

```
filebeat.inputs:
- type: log
  paths:
    - '/var/opt/allianz/logs/*.log'
  multiline.pattern: '^[[0-9]{2}-[A-Z][a-z]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  fields:
    environment: ["${ENVIRONMENT}"]
  fields_under_root: true
output:
  elasticsearch:
    hosts: ['<ip>:<port>']
    bulk_max_size: 16
    pipelining: 1
logging.level: debug
```