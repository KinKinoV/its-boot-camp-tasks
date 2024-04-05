terraform {
    source = "tfr:///terraform-aws-modules/vpc/aws?version=5.7.0"
}

locals {
    env_vars = read_terragrunt_config(find_in_parent_folders())
}

inputs = {
    cidr = local.env_vars.locals.vpc_cidr

    azs                     = local.env_vars.locals.azs_names
    public_subnets          = local.env_vars.locals.public_subnets_cidr
    map_public_ip_on_launch = true

    enable_nat_gateway = false

    tags = merge(
        local.env_vars.locals.tags,
        {
            Environmnet = local.env_vars.locals.env
        }
    )
}