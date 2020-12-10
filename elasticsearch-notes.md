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