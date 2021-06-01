# Ethereum Client Notes

## Geth

By default, Geth runs a mainnet node. Testnets are provided as options, e.g. `--ropsten`, `--rinkeby` or `--goerli`.

### Geth CLI Options
```
geth [--mainnet|--ropsten|--rinkeby|--goerli] --syncmode "fast"|"light" --datadir "/Volumes/<disk-name>/ethereum/geth" --datadir.minfreedisk 20480 [--http] [--http.api eth,net,web3,personal,debug] [--http.corsdomain "*"] [--ws] [--ws.api eth,net,web3,personal,debug] [--ws.origins "*"] --nat extip:$(curl --silent https://diagnostic.opendns.com/myip) [--maxpeers 0]
```

### Start Geth on macOS
```
caffeinate -i geth --mainnet --syncmode "fast" --datadir "/Volumes/<disk-name>/ethereum/geth" --datadir.minfreedisk 20480 --http --http.api eth,net,web3,personal,debug --http.corsdomain "*" --ws --ws.api eth,net,web3,personal,debug --ws.origins "*" --nat extip:$(curl --silent https://diagnostic.opendns.com/myip) 2>&1 | tee -a geth.log
caffeinate -i /usr/bin/nohup geth --mainnet --syncmode "fast" --datadir "/Volumes/<disk-name>/ethereum/geth" --datadir.minfreedisk 20480 --http --http.api eth,net,web3,personal,debug --http.corsdomain "*" --ws --ws.api eth,net,web3,personal,debug --ws.origins "*" --nat extip:$(curl --silent https://diagnostic.opendns.com/myip) 2>&1 & disown | tee -a geth.log
```
### Start Geth on Windows
```
geth --syncmode "light" --datadir "D:\ethereum" --datadir.minfreedisk 1048576 --http --http.api eth,net,web3,personal,debug --http.corsdomain "*" --ws --ws.api eth,net,web3,personal,debug --ws.origins "*" --nat extip:<ip-address> 2>&1 | ForEach-Object ToString | Tee-Object -FilePath "C:\logs\geth.log" -Append
```

### Geth JavaScript Console

#### Linux/macOS
```
geth attach
```
#### Windows
```
geth attach ipc:\\.\pipe\geth.ipc
```
#### Admin
```
admin.nodeInfo
admin.peers
admin.addPeer("enode://<public-key>@<ip-address>:<port>")
admin.chainSyncStatus
```

#### Network
```
net.listening
net.peerCount
```

#### Eth

eth.syncing = false when the node is up to date

```
eth.syncing
eth.blockNumber
```
