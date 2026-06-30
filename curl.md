# curl

## proxy
```
curl -iSs https://hostname -x|--proxy <[protocol://]proxy-host[:port]> [--noproxy "*|subdomain.domain.tld"]

# check if proxy establishes pure HTTPS tunnel with original certificate
# or uses SSL interception/inspection with replaced certificate
curl -v https://hostname -x|--proxy <[protocol://]proxy-host[:port]> | grep -E 'issuer|CAfile'
```

## cookie
```
curl -ikSsL --cookie cookie.txt --cookie-jar cookie.txt
```

## cacert
```
## curl uses a fallback mechanism from CAfile (--cacert) to CApath (--capath)
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

## time
```
curl -iSs <url> --connect-timeout 3.14 --max-time 5.5
```
