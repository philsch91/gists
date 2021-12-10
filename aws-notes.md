# AWS Notes

## EC2
```
# get NAT gateways (source IPs) for EC2 and EKS
#a aztecse-itmpagcs-intake-infraadmin
aws ec2 describe-nat-gateways --output json | jq -r '.NatGateways[].NatGatewayAddresses[].PrivateIp'
```
