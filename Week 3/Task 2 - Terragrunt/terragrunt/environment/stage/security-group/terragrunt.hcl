include "security-group" {
    path = "${get_terragrunt_dir()}/../../../modules/security-group/terragrunt.hcl"
    expose = true
}

include "root" {
    path = find_in_parent_folders()
    expose = true
}

dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        name = "mock_name"
        vpc_id = "vpc-fakeid"
    }
}

inputs = merge(
    include.security-group.inputs,
    {
        name        = "${dependency.vpc.outputs.name}_SG"
        description = "Security Group for EC2 Auto Scaling Group to host NodeJS container."
        vpc_id      = dependency.vpc.outputs.vpc_id
    }
)

dependencies {
    paths = ["../vpc"]
}