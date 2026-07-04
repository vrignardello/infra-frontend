terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "paraderos-terraform-state-225989346053"
    key          = "paraderos-frontend-demo/amplify/terraform.tfstate"
    region       = "us-east-1"
    profile      = "paraderos-admin"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

