GET _cat/indices/
GET _cat/indices/cisl-2020.11.27

GET cisl-2020.11.27/_search
{
    "query": {
        "match_all": {}
    }
}

GET cisl-2020.11.27/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "title":   "Search"        }},
        { "match": { "content": "Elasticsearch" }}
      ],
      "filter": [
        { "term":  { "status": "published" }},
        { "range": { "publish_date": { "gte": "2015-01-01" }}}
      ]
    }
  }
}

GET cisl-2020.11.27/_search?scroll=1m&format=txt

GET cisl-2020.11.27/_search?scroll=1m&pretty=true
{
    "size": 10000,
    "_source": ["@timestamp", "agent.hostname", "message"],
    "query": {
        "bool": {
           "must": [
              {"match": {"agent.hostname":"cisl-6-wtvhc"}},
              {"match": {"log.file.path": "/srv/tomcat/logs/catalina.2020-11-27.log"}}
            ],
            "filter": [
              {"range": {"@timestamp": { "gte": "2020-11-27T12:45:00.000Z" }}}
            ]
        }
    },
    "sort": [
      {
        "@timestamp": {
          "order": "asc"
        }
      }
    ]
}

GET cisl-2020.11.27/_search
{
    "query": {
        "bool": {
           "must": [
            ],
            "filter": [
              {"term": {"agent.hostname":"cisl-6-wtvhc"}},
              {"term": {"log.file.path": "/srv/tomcat/logs/catalina.2020-11-27.log"}}
            ]
        }
    }
}

PUT /beat-log4j-2020.12.04/_settings
{
  "index" : {
    "max_result_window": 100000
  }
}

GET beat-log4j-2020.12.04/_search?scroll=1m&pretty=true
{
    "size": 100000,
    "_source": ["@timestamp", "agent.hostname", "message"],
    "query": {
        "bool": {
           "must": [
              {"wildcard": {
                "agent.hostname": {
                "value": "cisl*"}
              }}
            ],
            "filter": [
              {"range": {"@timestamp": { "gte": "2020-12-04T08:39:31.000Z" }}}
            ]
        }
    },
    "sort": [
      {
        "@timestamp": {
          "order": "asc"
        }
      }
    ]
}

## filebeat.yml logstash example
```
filebeat.inputs:
- type: log
  paths:
    - /var/opt/allianz/logs/*.log
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
    - /var/opt/allianz/logs/*.log
output:
  elasticsearch:
    hosts: ['<ip>:<port>']
    bulk_max_size: 16
    pipelining: 1
```