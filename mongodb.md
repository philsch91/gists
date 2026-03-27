# MongoDB

## mongosh
```
# TLS
mongosh "mongodb://<user>:<password>@host:443/db?tls=true&tlsAllowInvalidCertificates=true&directConnection=true"

# MongoDB protocol
mongosh "mongodb://<user>:<password>@host:27017/db?tls=false"
```

## db.adminCommand
```
db.adminCommand({getLog: "global"})
```
