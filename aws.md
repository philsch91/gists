# AWS CLI

## Installation
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
mkdir -pv /tmp/awscliv2
unzip /tmp/awscliv2.zip -d /tmp/awscliv2
sudo /tmp/awscliv2/aws/install --update
which aws # /usr/local/bin/aws
aws --version
sudo rm -v /tmp/awscliv2.zip
sudo rm -rv /tmp/awscliv2
```

## Known Errors

`ImportError: cannot import name 'DEFAULT_CIPHERS' from 'urllib3.util.ssl_' (/home/<user>/.local/lib/python3.8/site-packages/urllib3/util/ssl_.py)`

```
pip install 'urllib3<2'
```

## IAM

### configure
```
aws configure --profile <profile-name>
less .aws/credentials
env | grep AWS_PROFILE
export AWS_PROFILE=<profile-name>

aws sts assume-role --role-arn arn:aws:iam::<account-id>:role/<role-name> --role-session-name "<role-session-name>"

export AWS_ACCESS_KEY_ID=abcd
export AWS_SECRET_ACCESS_KEY=abcd
export AWS_SESSION_TOKEN=abcd

aws sts get-caller-identity [--debug]

# TODO: check `eval "$(aws configure export-credentials --profile $profile_name --format env)"`

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
```

### configure sso
```
aws configure sso-session

export AWS_CONFIGURE_SSO_DEFAULT_SSO_START_URL="https://domain.awsapps.com/start"
export AWS_CONFIGURE_SSO_DEFAULT_SSO_REGION="eu-central-1"

aws configure set profile.$1.sso_start_url $AWS_CONFIGURE_SSO_DEFAULT_SSO_START_URL
aws configure set profile.$1.sso_region $AWS_CONFIGURE_SSO_DEFAULT_SSO_REGION

aws configure get profile.$1.sso_start_url
aws configure get profile.$1.sso_region

aws configure sso --profile $1
```

## sso
```
# TODO: review export-credentials
aws configure export-credentials --profile default | jq -r '.SecretAccessKey|.SessionToken'
aws sso list-accounts --access-token <access-token>
aws sso login --profile <profile-name>
#
1. aws sso login --profile <profile-name>
# `aws sso login` does not set the AWS_PROFILE var
# and use the sso_role_name of the profile
# as per `aws sts get-caller-identity`
2. export AWS_PROFILE=<profile-name>
3. aws sts get-caller-identity
4. aws sts assume-role --role-arn <role-arn>
# missing: a command to auto-export credentials like `eval "$(aws configure export-credentials --profile <profile-name> --format env)"`
5. export AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN
6. aws sts get-caller-identity
7. aws configure export-credentials
```

## EC2
```
# get NAT gateways (source IPs) for EC2 and EKS
#a <profile-name>
aws ec2 describe-nat-gateways --output json | jq -r '.NatGateways[].NatGatewayAddresses[].PrivateIp'
```

### VPC endpoint (VPCE) creation
```
# 1. get (private internal EKS worker) subnets
# 2. search dedicated security groups
aws ec2 describe-security-groups
# 3. create security group named with service or subnet tags
# sg_in-tcp-443_abs-intake-b
aws ec2 create-security-group
# 4. create security group rules for subnets
# named with common subnet name, like sgr_in-tcp-443_subnet_private-internal_86
# 5. add security group rules to security group
aws ec2 authorize-security-group-ingress
# 6. search shared vpc endpoint
aws ec2 describe-vpc-endpoints
# 7. create vpc endpoint for subnets and security groups
aws ec2 create-vpc-endpoint

## Security Group
aws ec2 describe-security-groups --filters '[{"Name": "group-name", "Values": ["<sg-name-1>","<sg-name-2>"]}, {"Name": "vpc-id", "Values": ["<vpc-id-1>","<vpc-id-2>"]}, {"Name": "ip-permission.cidr", "Values": ["<subnet-cidr>"]}]' --region <region-code>

### returns GroupId for security group ID
aws ec2 create-security-group --group-name sg-<id> --description 'Inbound TCP 443' --vpc-id vpc-<id> --tag-specifications '[{"ResourceType": "security-group", "Tags": [{"Key": "Name", "Value": "sg-<id>"},{"Key": "Owner", "Value": "<owner>"}]}]' --region <region-code> --dry-run

### pass GroupId for security group ID via --group-id
aws ec2 authorize-security-group-ingress --group-id sg-<id> [--group-name <group-id>] --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 443, "ToPort": 443, "IpRanges": [{"CidrIp": "192.168.1.0/24"},{"CidrIp": "192.168.2.0/24"}], "UserIdGroupPairs": [{"GroupId": "sg-<id>"}]}]' --region <region-code> --dry-run

## VPCE
aws ec2 describe-vpc-endpoints --filters '[{"Name": "group-name", "Values": ["<sg-name-1>","<sg-name-2>"]}, {"Name": "vpc-id", "Values": ["<vpc-id-1>","<vpc-id-2>"]}, {"Name": "ip-permission.cidr", "Values": ["<subnet-cidr>"]}, {"Name": "ip-permission.from-port", "Values": ["443"]}]' --region <region-code>

### pass GroupId for security group ID via --security-group-ids
aws ec2 create-vpc-endpoint --vpc-id vpc-<id> --service-name com.amazonaws.<region-code>.secretsmanager --vpc-endpoint-type Interface --subnet-ids subnet-1 subnet-2 subnet-3 --security-group-ids sg-1 sg-2 sg-3 --tag-specifications '[{"ResourceType": "vpc-endpoint", "Tags": [{"Key": "Name", "Value": "vpce_ecr_dkr"},{"Key": "Owner", "Value": "<owner>"}]}]' --region <region-code> --dry-run
```

## ELB
```
LB_HOSTNAME=$(kubectl -n <namespace-with-ingress-nginx-controller-deployment> get service/ingress-nginx-controller -o json | jq -r '.status.loadBalancer.ingress[0].hostname')
aws elb describe-load-balancers --load-balancer-names $LB_HOSTNAME | jq -r '.LoadBalancerDescriptions[].Subnets'
```

## EKS
```
aws eks describe-cluster --name <cluster-name> | jq -r '.cluster.resourcesVpcConfig.publicAccessCidrs'
aws eks describe-cluster --name <cluster-name> | jq -r .cluster.certificateAuthority.data | base64 -d
aws eks describe-cluster --name <cluster-name> | jq -r .cluster.endpoint

aws eks list-identity-provider-configs --cluster-name <cluster-name> [--region <region>]

aws eks associate-identity-provider-config --cluster-name <cluster-name> --oidc="<oidc-definition-json>"

aws eks describe-identity-provider-config --cluster-name <cluster-name> --identity-provider-config='{"type":"oidc", "name":"saml-org-com"}'

String identityProviderConfigJson=sh(script: "aws eks list-identity-provider-configs --cluster-name <cluster-name>", returnStdout: true)
LinkedHashMap identityProviderConfig = readJSON(text: identityProviderConfigJson, returnPojo: true)
if (identityProviderConfig["identityProviderConfigs"].size() == 0) {
    sh(script: """
        export jsonClient='{"identityProviderConfigName": "saml-org-com", "issuerUrl": "https://saml.org.com/oauth/", "clientId": "<client-id>", "usernameClaim": "email", "usernamePrefix": "oidc:", "groupsClaim": "groups", "groupsPrefix": "oidc:"}'
        aws eks associate-identity-provider-config --cluster-name <cluster-name> --oidc="\${jsonClient}"
    """)
}

aws eks list-nodegroups --cluster <cluster-name>

# drain node (instance) first
aws autoscaling terminate-instance-in-auto-scaling-group --instance-id <instance-id> --should-decrement-desired-capacity [--region <region>]

# eksctl
eksctl get nodegroup --cluster=<cluster-name> [--name=<nodegroup-name>]
eksctl scale nodegroup --cluster=<cluster-name> --name=<nodegroup-name> --nodes=<desired-count>  [--nodes-min=<min-size> ] [--nodes-max=<max-size>] [--wait]

# cordon + drain nodes and nodegroup
eksctl drain nodegroup --cluster=<clusterName> --name=<nodegroupName>
# uncordon nodes and nodegroup
eksctl drain nodegroup --cluster=<clusterName> --name=<nodegroupName> --undo

# drain all pods from the nodegroup, delete nodes and nodegroup
eksctl delete nodegroup --cluster=<clusterName> --name=<nodegroupName>
# delete nodes and nodegroup
eksctl delete nodegroup --cluster=<clusterName> --name=<nodegroupName> --disable-eviction
```

### EKS + EC2 Windows
```
k -n kube-system get cm/amazon-vpc-cni -o jsonpath='{.data.enable-windows-ipam}'
```

## S3
```
aws s3 ls s3://<bucket-name>
# no output because bucket was empty

aws s3 ls s3://<bucket-name>/<path>/<object>
2022-12-22 18:55:50         20 test.txt

# upload (copy)
aws s3 cp test.txt s3://bucket-name/test.txt
upload: test.txt to s3://bucket-name/test.txt

# read/get (copy)
aws s3 cp <S3-URL> - | less
```

## SSM
```
### returns Name for parameter
aws ssm describe-parameters --parameter-filters "Key=Name,Option=Contains,Values=<name>"
aws ssm describe-parameters --parameter-filters "Key=Name,Option=Contains,Values=s3-state-bucket"
aws ssm get-parameter --name <name> --with-decryption --query Parameter.Value
```

## ECR
```
aws ecr get-login-password | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.<aws-region>.amazonaws.com # updates $HOME/.docker/config.json
aws ecr describe-repositories --registry-id <aws-account-id> | jq -r '.repositories[].repositoryName'
aws ecr list-images --registry-id <aws-account-id> --repository-name <repo-name>
aws ecr describe-images --registry-id <aws-account-id> --repository-name <repo-name> [--query 'sort_by(imageDetails,& imagePushedAt)[*]' | --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]']
```

### ECR Public

#### Docker Registry HTTP API V2
```
curl -iSs https://ecr-public.aws.com/docker/library/redis:7.2.11-alpine
HTTP/2 401
date: Wed, 22 Oct 2025 07:51:35 GMT
content-type: application/json; charset=utf-8
content-length: 58
docker-distribution-api-version: registry/2.0
www-authenticate: Bearer realm="https://ecr-public.aws.com/token/",service="public.ecr.aws",scope="aws"
proxy-support: Session-Based-Authentication

{"errors":[{"code":"DENIED","message":"Not Authorized"}]}
```

```
TOKEN=$(curl -Ls -X GET "https://ecr-public.aws.com/token?service=public.ecr.aws&scope=repository:docker/library/redis:pull" | jq -r '.token')
curl -iSs -H "Authorization: Bearer $TOKEN" https://ecr-public.aws.com/v2/docker/library/redis/manifests/7.2.11-alpine
```
