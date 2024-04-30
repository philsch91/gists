# ACME

```
curl -ikSs http://<acme-uri>/directory
curl -IkSs -w '%header{replay-nonce}' http://<acme-uri>/acme/new-nonce
curl -ikSsv -X POST http://<acme-uri>/acme/new-acct \
    -H 'Content-Type: application/jose+json' \
    -H 'Content-Length: 28' \
    -d '{"onlyReturnExisting": true}'
curl -ikSsv -X POST http://<acme-uri>/acme/new-order
```
