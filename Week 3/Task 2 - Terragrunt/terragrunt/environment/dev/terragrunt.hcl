locals {
    profile              = "default"
    aws_region           = "us-east-1"
    bucket               = "my-all-terraform-states"
    dynamodb_table       = "terraform-state-lock"
    env                  = "dev"
    common_name          = "DEV"
    ami                  = "ami-02d7fd1c2af6eead0"
    vpc_cidr             = "100.0.0.0/16"
    azs_names            = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    public_subnets_cidr  = ["100.0.1.0/24", "100.0.2.0/24", "100.0.3.0/24", "100.0.4.0/24", "100.0.5.0/24", "100.0.6.0/24"]
    health_target        = "/info"
    min_ASG_capacity     = 1
    max_ASG_capacity     = 2
    desired_ASG_capacity = 1
    tags = {
        Terragrunt = "true"
    }
}

generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "aws" {
    region  = "${local.aws_region}"
    profile = "${local.profile}"
}
EOF
}

remote_state {
    backend = "s3"
    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
    config = {
        bucket         = "${local.bucket}"
        key            = "dev/${path_relative_to_include()}/terraform.tfstate"
        region         = "${local.aws_region}"
        dynamodb_table = "${local.dynamodb_table}"
        encrypt        = true
    }
}