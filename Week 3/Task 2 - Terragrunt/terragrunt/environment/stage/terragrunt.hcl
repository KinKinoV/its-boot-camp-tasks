locals {
    profile              = "default"
    aws_region           = "us-east-1"
    bucket               = "my-all-terraform-states"
    dynamodb_table       = "terraform-state-lock"
    env                  = "stage"
    common_name          = "STAGE"
    ami                  = "ami-02d7fd1c2af6eead0"
    vpc_cidr             = "300.0.0.0/16"
    azs_names            = ["us-east-1a"]
    public_subnets_cidr  = ["300.0.1.0/24"]
    health_target        = "/info"
    min_ASG_capacity     = 1
    max_ASG_capacity     = 1
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
        key            = "stage/${path_relative_to_include()}/terraform.tfstate"
        region         = "${local.aws_region}"
        dynamodb_table = "${local.dynamodb_table}"
        encrypt        = true
    }
}