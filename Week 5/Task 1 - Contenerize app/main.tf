terraform {
  required_version = ">= 1.7.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.32"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

locals {
  tags = {
    Terraform = "True",
    Docker    = "True"
  }
}
