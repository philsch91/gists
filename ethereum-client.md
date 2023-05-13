# Ethereum Client

## Geth

By default, Geth runs a mainnet node. Testnets are provided as options, e.g. `--ropsten`, `--rinkeby` or `--goerli`.

### Geth CLI Options
```
geth [--mainnet|--ropsten|--rinkeby|--goerli] --syncmode "snap|light|fast" --datadir "/Volumes/<disk-name>/ethereum/geth" --datadir.minfreedisk 20480 [--snapshot=false] [--http] [--http.addr <ip>] [--http.api eth,net,web3,personal,debug] [--http.corsdomain "*"] [--ws] [--ws.addr <ip>] [--ws.api eth,net,web3,personal,debug] [--ws.origins "*"] --nat extip:$(curl --silent https://diagnostic.opendns.com/myip) [--maxpeers 0]
```

### Start Geth on macOS
```
caffeinate -i geth --mainnet --syncmode "fast" --datadir "/Volumes/<disk-name>/ethereum/geth" --datadir.minfreedisk 20480 --http --http.api eth,net,web3,personal,debug --http.corsdomain "*" --ws --ws.api eth,net,web3,personal,debug --ws.origins "*" --nat extip:$(curl --silent https://diagnostic.opendns.com/myip) 2>&1 | tee -a geth.log
caffeinate -i /usr/bin/nohup geth --mainnet --syncmode "fast" --datadir "/Volumes/<disk-name>/ethereum/geth" --datadir.minfreedisk 20480 --http --http.api eth,net,web3,personal,debug --http.corsdomain "*" --ws --ws.api eth,net,web3,personal,debug --ws.origins "*" --nat extip:$(curl --silent https://diagnostic.opendns.com/myip) 2>&1 & disown | tee -a geth.log
```
### Start Geth on Windows
```
// mainnet light sync
geth --syncmode "light" --datadir "D:\ethereum" --datadir.minfreedisk 1048576 --http --http.addr $((Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4Address).IPAddress) --http.api eth,net,web3,personal,debug --http.corsdomain "*" --ws --ws.addr $((Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4Address).IPAddress) --ws.api eth,net,web3,personal,debug --ws.origins "*" --nat extip:$((Invoke-WebRequest -Uri https://diagnostic.opendns.com/myip).Content) 2>&1 | ForEach-Object ToString | Tee-Object -FilePath "C:\logs\geth.log" -Append
// mainnet light sync 20220717 Geth v1.10.20
geth --syncmode "light" --datadir "D:\ethereum" --datadir.minfreedisk 1048576 --snapshot=false --http --http.addr $((Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4Address).IPAddress) --http.api eth,net,web3,personal,debug --http.corsdomain "*" --ws --ws.addr $((Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4Address).IPAddress) --ws.api eth,net,web3,personal,debug --ws.origins "*" --nat extip:$((Invoke-WebRequest -Uri https://myip.dnsomatic.com).Content) 2>&1 | ForEach-Object ToString | Tee-Object -FilePath "C:\logs\geth.log" -Append
// ropsten testnet light sync
geth --ropsten --syncmode "light" --datadir "D:\ethereum-ropsten" --datadir.minfreedisk 1048576 --http --http.addr $((Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4Address).IPAddress) --http.api eth,net,web3,personal,debug --http.corsdomain "*" --ws --ws.addr $((Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4Address).IPAddress) --ws.api eth,net,web3,personal,debug --ws.origins "*" --nat extip:$((Invoke-WebRequest -Uri https://diagnostic.opendns.com/myip).Content) 2>&1 | ForEach-Object ToString | Tee-Object -FilePath "C:\logs\geth-ropsten.log" -Append
// mainnet snap sync 20220715 Geth v1.10.20
geth --syncmode "snap" --datadir "D:\ethereum" --datadir.minfreedisk 524288 --http --http.addr $((Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4Address).IPAddress) --http.api eth,net,web3,personal,debug --http.corsdomain "*" --ws --ws.addr $((Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4Address).IPAddress) --ws.api eth,net,web3,personal,debug --ws.origins "*" --nat extip:$((Invoke-WebRequest -Uri https://myip.dnsomatic.com).Content) 2>&1 | ForEach-Object ToString | Tee-Object -FilePath "C:\logs\geth.log" -Append
// mainnet snap sync 20230513 Geth v.1.11.6
geth --syncmode "snap" --datadir "D:\ethereum" --datadir.minfreedisk 524288 --http --http.addr $((Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4Address).IPAddress) --http.api eth,net,web3,personal,debug --http.corsdomain "*" --ws --ws.addr $((Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4Address).IPAddress) --ws.api eth,net,web3,personal,debug --ws.origins "*" --authrpc.addr localhost --authrpc.port 8551 --authrpc.vhosts * --authrpc.jwtsecret "D:\ethereum\geth\jwtsecret" --nat extip:$((Invoke-WebRequest -Uri https://myip.dnsomatic.com).Content) 2>&1 | ForEach-Object ToString | Tee-Object -FilePath "C:\logs\geth.log" -Append
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
eth.syncing.highestBlock - eth.syncing.currentBlock
eth.blockNumber
```

## Lighthouse

### Lighthouse on Windows
```
lighthouse bn --network mainnet --datadir "D:\lighthouse" --logfile "C:\logs\lighthouse\lighthouse.log" --http-webprovider "localhost:8551" --jwt-secret "D:\ethereum\geth\jwtsecret" --checkpoint-sync-url "https://mainnet.checkpoint.sigp.io" --http --disable-deposit-contract-sync 2>&1 | ForEach-Object ToString | Tee-Object -FilePath "C:\logs\lighthouse.log" -Append
lighthouse bn --network mainnet --datadir "D:\lighthouse" --logfile "C:\logs\lighthouse\lighthouse.log" --execution-endpoint "http://localhost:8551" --execution-jwt "D:\ethereum\geth\jwtsecret" --checkpoint-sync-url "https://mainnet.checkpoint.sigp.io" --http --disable-deposit-contract-sync 2>&1 | ForEach-Object ToString | Tee-Object -FilePath "C:\logs\lighthouse.log" -Append
```
