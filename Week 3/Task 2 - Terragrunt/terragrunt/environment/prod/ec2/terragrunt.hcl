include "root" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${get_terragrunt_dir()}/../../../modules/ec2"
}

locals {
    env_vars = read_terragrunt_config(find_in_parent_folders())
}

dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        public_subnets = ["mock_public_subnet1", "mock_public_subnet2"]
    }
}

inputs = {
    ami = local.env_vars.locals.ami
    instance_subnet_id = dependency.vpc.outputs.public_subnets[0]
    assign_public_ip = true

    tags = {
        Terragrunt = true,
        Name = "${local.env_vars.locals.env}-terragrunt-ec2"
    }
}