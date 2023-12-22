# curl

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
