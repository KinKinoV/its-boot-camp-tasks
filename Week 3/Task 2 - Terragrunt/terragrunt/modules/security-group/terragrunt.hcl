terraform {
    source = "tfr:///terraform-aws-modules/security-group/aws?version=5.1.2"
}

locals {
    env_vars = read_terragrunt_config(find_in_parent_folders())
}

inputs = {
    ingress_cidr_blocks = ["0.0.0.0/0"]
    ingress_rules       = ["http-80-tcp", "ssh-tcp", "all-icmp"]

    egress_cidr_blocks = [ "0.0.0.0/0" ]
    egress_rules       = ["all-all"]

    tags = merge(
        local.env_vars.locals.tags,
        {
            Environmnet = local.env_vars.locals.env
        }
    )
}