terraform {
  cloud {
    organization = "JR4_AWS_Testing"
    workspaces {
      name = "CloudRC_Static_Website"
    }
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.19.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

module "iam-user" {
  source  = "terraform-aws-modules/iam/aws"
  version = "5.39.1"
}

