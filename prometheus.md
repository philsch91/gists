# Prometheus

## Prometheus Flags

```
prometheus --config.file=/etc/prometheus/prometheus.yml [--web.listen-address="0.0.0.0:9090"] [--web.read-timeout=5m] [--web.max-connections=512] [--web.external-url=<URL>] [--web.route-prefix=<path>] [--web.user-assets=<path>] --web.enable-lifecycle --web.enable-admin-api --web.console.libraries=/etc/prometheus/console_libraries --web.console.templates=/etc/prometheus/consoles --web.cors.origin=".*" --storage.tsdb.path=/prometheus [--storage.tsdb.retention=7d (deprecated)|--storage.tsdb.retention.time=7d (default=15d, overrides storage.tsdb.retention)|--storage.tsdb.retention.size=20GB (default=0,disabled)] [--storage.tsdb.allow-overlapping-blocks] [--storage.tsdb.wal-compression] [--storage.tsdb.no-lockfile] [--storage.remote.flush-deadline=<duration>] [--rules.alert.for-outage-tolerance=1h] [--rules.alert.for-grace-period=10m] [--rules.alert.resend-delay=1m] [--alertmanager.notification-queue-capacity=10000] [--alertmanager.timeout=10s] [--query.lookback-delta=5m] [--query.timeout=2m] [--query.max-concurrency=20] [--query.max-samples=50000000] --log.level=info --log.format=logfmt [-web.enable-remote-shutdown]
```

## HTTP API

```
curl -X POST 'http://localhost:9090/api/v1/admin/tsdb/clean_tombstones'
```