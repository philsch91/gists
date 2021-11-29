# Prometheus Notes

## Prometheus Flags

```
prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus --web.enable-lifecycle --web.console.libraries=/etc/prometheus/console_libraries --web.console.templates=/etc/prometheus/consoles [--storage.tsdb.retention=7d (deprecated)|--storage.tsdb.retention.time=7d (default=15d, overrides storage.tsdb.retention)|--storage.tsdb.retention.size=20GB (default=0,disabled)] [--storage.tsdb.wal-compression] --web.enable-admin-api [-web.enable-remote-shutdown]
```

## HTTP API

```
curl -X POST 'http://localhost:9090/api/v1/admin/tsdb/clean_tombstones'
```