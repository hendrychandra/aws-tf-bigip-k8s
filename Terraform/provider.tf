


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
  # Reference : https://discuss.hashicorp.com/t/using-credential-created-by-aws-sso-for-terraform/23075/4
  profile = "A-User-Profile"
}


