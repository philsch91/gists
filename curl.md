# curl

## proxy
```
curl -iSs https://host -x | --proxy <[protocol://]host[:port]>
```

## cookie
```
curl -ikSsL --cookie cookie.txt --cookie-jar cookie.txt
```

## cacert
```
curl -iSs --cacert certs.pem <url>
```

## capath
```
curl -iSs --capath <path-to-pem-certs> <url>
```

## tls
```
curl -iSs --tlsv1.2 --tls-max 1.2 <url>
```

## data-binary
```
curl -L -u <username>:<password> -X POST <url> --data-binary "@path/to/file.json"
```
