include "vpc" {
    path = "${get_terragrunt_dir()}/../../../modules/vpc/terragrunt.hcl"
    expose = true
}

include "root" {
    path = find_in_parent_folders()
    expose = true
}

inputs = merge(
    include.vpc.inputs,
    {
        name = "${include.root.locals.env}-${include.root.locals.common_name}-VPC"
    }
)