terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    sdm = {
      source = "strongdm/sdm"
      version = ">=3.3.0"
    }
  }

    backend "s3" {
    bucket = "strongdm-challenge-backend-2"
      key = "strongdm-challenge/terraform.tfstate"
      region = "us-west-2"
    }
}

provider "aws" {
  region = var.aws_region
}

provider "sdm" {
  api_access_key = var.SDM_API_ACCESS_KEY
  api_secret_key = var.SDM_API_SECRET_KEY
}