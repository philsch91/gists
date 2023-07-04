# AWS Notes

## IAM
```
aws configure --profile <profile-name>
less .aws/credentials
env | grep AWS_PROFILE
export AWS_PROFILE=<profile-name>

aws sts assume-role --role-arn arn:aws:iam::<account-id>:role/<role-name> --role-session-name "<role-session-name>"

export AWS_ACCESS_KEY_ID=abcd
export AWS_SECRET_ACCESS_KEY=abcd
export AWS_SESSION_TOKEN=abcd

aws sts get-caller-identity

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
```

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

## S3
```
aws s3 ls s3://bucket-name
<no output because bucket was empty>

aws s3 cp test.txt s3://bucket-name/test.txt
upload: test.txt to s3://bucket-name/test.txt

aws s3 ls s3://bucket-name
2022-12-22 18:55:50         20 test.txt
```
