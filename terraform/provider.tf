terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"  # Pin to the last stable v4 version
    }
  }

  required_version = ">= 1.3.0"
}

locals {
  region = "us-east-1"
  name   = "eks-cluster"
  vpc_cidr = "10.123.0.0/16"
  azs      = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.123.1.0/24", "10.123.2.0/24"]
  private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
  intra_subnets   = ["10.123.5.0/24", "10.123.6.0/24"]
  tags = {
    Example = local.name
  }
}

provider "aws" {
  region = local.region
}
