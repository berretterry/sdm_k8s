terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

    backend "s3" {
    bucket = "cssandbox-sdm-k8s"
      key = "cssandbox-sdm-k8s/terraform.tfstate"
      region = "us-west-2"
    }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}
