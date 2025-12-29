# Terraform

## config.tf

### backend "local"
```
terraform {
  required_version = ">= 0.13.4"

  backend "local" {
    path = "terraform.tfstate"
  }
}
```

### backend "s3"
```
terraform {
  required_version = ">= 0.13.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = ">= 5.26"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    key    = "prod/eks-sg/terraform.tfstate"
    region = var.region
  }
}

provider "aws" {
  # assume_role {
  #   role_arn     = var.role_arn
  #   session_name = "terraform-deploy"
  # }
  # profile = var.profile
  region  = var.region
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
terraform version
terraform [-chdir=terraform/aws] init [-backend-config tf-backend.config]
terraform fmt [-check] [-recursive] resource.tf
terraform [-chdir=terraform/aws] plan [-destroy] [-var-file="testing.tfvars(.json)"] [-var 'name=value'] [-var 'listname=["a", "b", "c"]'] [-input=false] [-out terraform.tfplan] [-detailed-exitcode]
terraform [-chdir=terraform/aws] apply [-destroy] [-var-file="testing.tfvars(.json)"] [-input=false] [terraform.tfplan]
```

## init

### terraform.tfstate
```
{
  "version": 3,
  "terraform_version": "1.11.0",
  "backend": {
    "type": "s3",
    "config": {
      "access_key": null,
      "acl": null,
      "allowed_account_ids": null,
      "assume_role": null,
      "assume_role_with_web_identity": null,
      "bucket": "s3-ec1-012345678910-tf-backend",
      "custom_ca_bundle": null,
      "dynamodb_endpoint": null,
      "dynamodb_table": null,
      "ec2_metadata_service_endpoint": null,
      "ec2_metadata_service_endpoint_mode": null,
      "encrypt": true,
      "endpoint": null,
      "endpoints": null,
      "forbidden_account_ids": null,
      "force_path_style": null,
      "http_proxy": null,
      "https_proxy": null,
      "iam_endpoint": null,
      "insecure": null,
      "key": "prod/eks-sg/terraform.tfstate",
      "kms_key_id": null,
      "max_retries": null,
      "no_proxy": null,
      "profile": null,
      "region": "eu-central-1",
      "retry_mode": null,
      "secret_key": null,
      "shared_config_files": null,
      "shared_credentials_file": null,
      "shared_credentials_files": null,
      "skip_credentials_validation": null,
      "skip_metadata_api_check": null,
      "skip_region_validation": null,
      "skip_requesting_account_id": null,
      "skip_s3_checksum": null,
      "sse_customer_key": null,
      "sts_endpoint": null,
      "sts_region": null,
      "token": null,
      "use_dualstack_endpoint": null,
      "use_fips_endpoint": null,
      "use_lockfile": true,
      "use_path_style": null,
      "workspace_key_prefix": null
    },
    "hash": 3772953468
  }
}
```

## Debugging
`export TF_LOG="TRACE|DEBUG|INFO|WARN|ERROR"`
