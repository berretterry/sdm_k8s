terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

    backend "s3" {
    bucket = "strongdm-challenge-backend-1"
      key = "strongdm-challenge/terraform.tfstate"
      region = "us-west-2"
    }
}

provider "aws" {
  region = var.aws_region
}
