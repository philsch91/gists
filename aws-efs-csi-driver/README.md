# Amazon EFS CSI Driver

## Create IAM policy and role
```
aws iam create-policy \
    --policy-name <eks-cluster-name>-efs-csi-driver-policy \
    --policy-document file://iam-policy.json

aws eks describe-cluster --name <cluster-name> --query "cluster.identity.oidc.issuer" --output text
// example: aws eks describe-cluster --name adpk8s-adsr-intake-b --query "cluster.identity.oidc.issuer" --output text
```

The text output will look like `https://oidc.eks.eu-central-1.amazonaws.com/id/xxxxx` and needs to be replaced in `trust-policy.json`.

```
aws iam create-role \
  --role-name <eks-cluster-name>-efs-csi-driver-role \
  --assume-role-policy-document file://"trust-policy.json"

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::<aws-account-id>:policy/<eks-cluster-name>-efs-csi-driver-policy \
  --role-name <eks-cluster-name>-efs-csi-driver-role
```

## Install EFS driver
```
// replace value for key eks.amazonaws.com/role-arn in efs-sa.yaml with ARN of created role
kubectl -n kube-system apply -f efs-sa.yaml
// create 0-efs-csi-driver PodSecurityPolicy, eks:podsecuritypolicy-cluster:efs-csi ClusterRole
// and eks:podsecuritypolicy-cluster:efs-csi ClusterRoleBinding
kubectl -n kube-system create -f crp-psp-roles.yaml
// create efs.csi.aws.com CSIDriver, efs-csi-controller Deployment
// and efs-csi-node DaemonSet
kubectl -n kube-system create -f crp-efs-csi.yaml
kubectl logs -f --tail 100 efs-csi-controller-7dd559579d-f9xqm -c csi-provisioner
```

## Create EFS file system
```
vpc_id=$(aws eks describe-cluster \
--name adpk8s-<cluster-name> \
--query "cluster.resourcesVpcConfig.vpcId" \
--output text)

cidr_range=$(aws ec2 describe-vpcs \
--vpc-ids $vpc_id \
--query "Vpcs[].CidrBlock" \
--output text)

security_group_id=$(aws ec2 create-security-group \
--group-name rl-shared-efs-security-group \
--description "RL SHARED EFS Security Group" \
--vpc-id $vpc_id \
--output text)

aws ec2 authorize-security-group-ingress \
    --group-id $security_group_id \
    --protocol tcp \
    --port 2049 \
    --cidr $cidr_range
```

```
export file_system_id=$(aws efs create-file-system \
    --region <region> \
    --performance-mode generalPurpose \
    --query 'FileSystemId' \
    --output text)
```

## Attach and Mount EFS
```
// replace value for key fileSystemId in efs-sa.yaml with $file_system_id
kubectl -n kube-system create -f efs-sc.yaml
```

#### Create Mount Targets in Subnets for Worker Nodes

Subnet 1 for Worker Nodes - Availability Zone A
```
aws efs create-mount-target \
    --file-system-id $file_system_id \
    --subnet-id subnet-xxxx \
    --security-groups $security_group_id
```

Subnet 2 for Worker Nodes - Availability Zone B
```
aws efs create-mount-target \
    --file-system-id $file_system_id \
    --subnet-id subnet-xxxx \
    --security-groups $security_group_id
```

```
// look for: successfully created PV pvc-5983ffec-96cf-40c1-9cd6-e5686ca84eca for PVC efs-claim and csi volume name fs-95bcec92::fsap-02a88145b865d3a87
kubectl logs -f --tail 100 efs-csi-controller-7dd559579d-f9xqm -c csi-provisioner

// check volume for status Bound
kubectl get pv

// view pvc details
kubectl get pvc
```
