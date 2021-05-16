# Ethereum Client Notes

## Geth

By default, Geth runs a mainnet node. Testnets are provided as options, e.g. `--ropsten`, `--rinkeby` or `--goerli`.

### Geth CLI Options
```
geth --syncmode "light" --datadir.minfreedisk 20480  --nat extip:$(curl --silent https://diagnostic.opendns.com/myip)
geth --mainnet --syncmode "fast" --datadir "/Volumes/<disk-name>/ethereum/geth" --datadir.minfreedisk 20480  --nat extip:$(curl --silent https://diagnostic.opendns.com/myip)
```

### Start Geth on macOS
```
caffeinate -i geth --mainnet --syncmode "fast" --datadir "/Volumes/<disk-name>/ethereum/geth" --datadir.minfreedisk 20480  --nat extip:$(curl --silent https://diagnostic.opendns.com/myip)
```

### Geth JavaScript Console
```
geth attach
```

### Node Info
```
admin.nodeInfo
```

### Network Connectivity
```
net.listening
net.peerCount
```

### P2P
```
admin.peers
admin.addPeer("enode://<public-key>@<ip-address>:<port>")
```
