# Terraform

## config.tf
```
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```

## main.tf
```
# The attribute `${data.aws_caller_identity.current.account_id}` will be current account number.
data "aws_caller_identity" "current" {} # data.aws_caller_identity.current.account_id
# The attribute `${data.aws_region.current.name}` will be current region
data "aws_region" "current" {}  # data.aws_region.current.name

locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
}
```

## Usage
```
terraform init
terraform plan [-destroy] [-var-file="testing.tfvars(.json)"] [-var 'name=value'] [-var 'listname=["a", "b", "c"]'] [-out terraform.tfplan]
terraform apply [-destroy] [-var-file="testing.tfvars(.json)"] [terraform.tfplan]
```

## Debugging
`export TF_LOG="TRACE|DEBUG|INFO|WARN|ERROR"`
