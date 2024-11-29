terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "main" {
  cidr_block = "237.84.2.178/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "main VPC"
  }
  
}