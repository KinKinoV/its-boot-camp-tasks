terraform {
  required_version = ">= 1.7.5"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 5.32"
    }
  }

  backend "s3" {
    bucket = "my-all-terraform-states"
    key = "prod/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

locals {
  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }
}

data "aws_ami" "amzlinux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}