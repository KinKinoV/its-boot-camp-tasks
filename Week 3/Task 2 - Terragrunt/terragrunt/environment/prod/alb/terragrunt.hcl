include "alb" {
    path = "${get_terragrunt_dir()}/../../../modules/alb/terragrunt.hcl"
    expose = true
}

include "root" {
    path = find_in_parent_folders()
    expose = true
}

dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        public_subnets = ["mock_public_subnet_1", "mock_public_subnet_2"]
        vpc_id = "vpc-fakeid"
    }
}

inputs = merge(
    include.alb.inputs,
    {
        vpc_id  = dependency.vpc.outputs.vpc_id
        subnets = dependency.vpc.outputs.public_subnets
    }

)

dependencies {
    paths = ["../vpc"]
}