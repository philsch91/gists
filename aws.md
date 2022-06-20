# AWS Notes

## EC2
```
# get NAT gateways (source IPs) for EC2 and EKS
#a <profile-name>
aws ec2 describe-nat-gateways --output json | jq -r '.NatGateways[].NatGatewayAddresses[].PrivateIp'
```

## EKS
```
aws eks describe-cluster --name <cluster-name> | jq -r '.cluster.resourcesVpcConfig.publicAccessCidrs'
```
