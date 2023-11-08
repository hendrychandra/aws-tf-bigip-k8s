


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws-region
  # Reference : https://discuss.hashicorp.com/t/using-credential-created-by-aws-sso-for-terraform/23075/4
  profile = var.aws-cli-profile
}


