# Terraform

## Variables
```
export TF_LOG="TRACE|DEBUG|INFO|WARN|ERROR"
```

## config.tf

- `terraform.backend` should be omitted for the backend initialization

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

#### aws provider ~> 6.0
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

  # should be omitted for the backend initialization
  backend "s3" {
    bucket = "s3-<account-id>-<region>-tf-backend"
    key = "prod/eks-sg/terraform.tfstate"
    region = var.region
    encrypt = true
    use_lockfile = true
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

#### aws provider ~> 5.0
```
terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # should be omitted for the backend initialization
  backend "s3" {
    bucket         = "s3-<account-id>-<region>-tf-backend"
    key            = "iam/ec2-instance-manager/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "ec1-tf-backend-dynamodb"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}
```

### backend "azurerm"
```
terraform {
  required_version = ">= 0.13.4"

  required_providers {
    azurerm  = ">= 2.19.0"
    null = "= 2.1.2"
  }

  # should be omitted for the backend initialization
  backend "azurerm" {
    # Further configuration can be found in the backend init
    key = "terraform-backend-init/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  region = var.region
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

## backend.tfvars
```
bucket       = "<state-bucket>"
region       = "<region>"
encrypt      = true
use_lockfile = true
```

## state
```
terraform [-chdir=terraform/aws] state list
## asume_role = iam-assumable-role module source code naming
## assume_role_with_oidc = iam-assumable-role-with-oidc
# data.aws_caller_identity.current
# data.aws_iam_policy.boundary
# aws_iam_policy.ecr_policy
# module.ecr_role.data.aws_caller_identity.current
# module.ecr_role.data.aws_iam_policy_document.assume_role[0]
# module.ecr_role.data.aws_partition.current
# module.ecr_role.aws_iam_role.this[0]
# module.ecr_role.aws_iam_role_policy_attachment.custom[0]
```

## Usage
```
# version
terraform version

# init
[echo yes |] terraform [-chdir=terraform/aws] init [-backend-config backend.tfvars]

INIT_EXIT_CODE=$?

echo "Terraform init exit code: ${INIT_EXIT_CODE}"

# fmt
terraform fmt [-check] [-recursive] resource.tf

# workspace list
terraform workspace list

# workspace select
terraform workspace select "<workspace-name(ap-southeast-2-tf-backend)>" || terraform workspace new "<workspace-name(ap-southeast-2-tf-backend)>"

# state list
terraform [-chdir=terraform/aws] state list

# plan
terraform [-chdir=terraform/aws] plan [-destroy] [-input=false] [-var-file="testing.tfvars(.json)"] [-var 'name=value'] [-var 'listname=["a", "b", "c"]'] [-out terraform.tfplan] [-detailed-exitcode]

PLAN_EXIT_CODE=$?

# exit code 2 indicates success and changes to apply
if [ ${PLAN_EXIT_CODE} -ne 2 ]; then
    echo "Error during terraform plan."
    exit 1
fi

# apply
terraform [-chdir=terraform/aws] apply [-destroy] [-var-file="testing.tfvars(.json)"] [-input=false] [terraform.tfplan]

# output
terraform [-chdir=terraform/aws] output [-no-color] -json
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

## tfenv
```
tfenv list-remote
tfenv install latest
tfenv use latest
tfenv install 1.11.0
tfenv use 1.11.0
terraform -v
```
