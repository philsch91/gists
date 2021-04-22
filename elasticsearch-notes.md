# Elasticsearch Notes

### Cat API
```
GET _cat/indices/
GET _cat/indices?pretty=true
GET _cat/indices/<index-name>-2020.11.27
GET _cat/nodes
DELETE <index-name>-2020.12.15
DELETE <index-name>*
DELETE *2021.02.01
GET <index-name>/_settings
GET */_settings
GET _cluster/settings
```
```
PUT _cluster/settings
{
  "persistent": {
    "cluster.routing.allocation.disk.threshold_enabled": true,
    "cluster.routing.allocation.disk.watermark.flood_stage": "95%",
    "cluster.routing.allocation.disk.watermark.low": "85%",
    "cluster.routing.allocation.disk.watermark.high": "90%",
    "cluster.info.update.interval": "1m"
  }
}
```

```
PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.disk.threshold_enabled": true,
    "cluster.routing.allocation.disk.watermark.low": "100gb",
    "cluster.routing.allocation.disk.watermark.high": "50gb",
    "cluster.routing.allocation.disk.watermark.flood_stage": "10gb",
    "cluster.info.update.interval": "1m"
  }
}
```

### Settings
```
PUT _settings
{
  "index": {
    "blocks": {
      "read_only_allow_delete": "false"
    }
  }
}
```

```
PUT .kibana/_settings
{
  "index": {
    "blocks": {
      "read_only_allow_delete": "false"
    }
  }
}
```

```
PUT .opendistro_security/_settings
{
  "index": {
    "blocks": {
      "read_only_allow_delete": "false"
    }
  }
}
```
```
PUT <index-name>/_settings
{
  "index.blocks.read_only_allow_delete": null
}
```

```
 for index in $(curl -u testadmin:test123 -X GET localhost:9200/_cat/indices?health=yellow | cut -f3 -d' '); do curl -u testadmin:test123 -X PUT -H "Content-Type: application/json" http://localhost:9200/${index}/_settings -d '{"index.blocks.read_only_allow_delete": "false"}'; done
```

### Search
```
GET cisl-2020.11.27/_search
{
    "query": {
        "match_all": {}
    }
}
```

```
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
```

```
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
```

### Scroll API
```
GET cisl-2020.11.27/_search?scroll=1m&format=txt
```

```
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
```

### Index Settings
```
PUT /beat-log4j-2020.12.04/_settings
{
  "index" : {
    "max_result_window": 100000
  }
}
```

### Search and Scroll
```
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
```

```
GET beat-log4j-2021.01.14/_search?scroll=1m&pretty=true
{
    "size": 100000,
    "_source": ["@timestamp", "appName.keyword", "message"],
    "query": {
        "bool": {
           "must": [
              {"wildcard": {
                "appName.keyword": {
                "value": "mo-bff*"}
              }}
            ],
            "filter": [
              {"range": {"@timestamp": { "gte": "2021-01-14T00:00:00.000Z" }}}
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
```

### Kibana Console Proxy

Access Elasticsearch API via Kibana

#### GET _cluster/health
```
curl -k 'https://<kibana-uri>/api/console/proxy?path=_cluster%2Fhealth&method=GET' -X 'POST' -H 'kbn-xsrf: true' -u '<user>:<password>'
```
#### GET _cluster/pending_tasks
```
curl -k 'https://<kibana-uri>/api/console/proxy?path=_cluster%2Fpending_tasks&method=GET' -X 'POST' -H 'kbn-xsrf: true' -u '<user>:<password>'
````
#### GET _cat/indices
```
curl -k 'https://<kibana-uri>/api/console/proxy?path=_cat%2Findices&method=GET' -X 'POST' -H 'kbn-xsrf: true' -u '<user>:<password>'
```

#### GET */_settings
```
curl -k 'https://<kibana-uri>/api/console/proxy?path=%2A%2F_settings&method=GET' -X 'POST' -H 'kbn-xsrf: true' -u '<user>:<password>'
```
Check for response
```
"index-name": {
  "settings": {
    "index": {
      "blocks": {
        "read_only_allow_delete": "true"
      }
    }
  }
}
```
