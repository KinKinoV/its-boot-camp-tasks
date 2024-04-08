module "Ansible_VPC" {
    source = "terraform-aws-modules/vpc/aws"
    version = "= 5.7.0"

    name = "ansible-vpc"
    cidr = var.vpc_cidr

    azs = var.azs
    public_subnets  = [for k,v in var.azs: cidrsubnet(var.vpc_cidr, 8, k+10)]
    private_subnets = [for k,v in var.azs: cidrsubnet(var.vpc_cidr, 8, k+1)]

    enable_nat_gateway = true

    tags = local.tags
}

module "AnsibleVPC_SG" {
    source = "terraform-aws-modules/security-group/aws"
    version = "= 5.1.2"

    name = "${module.Ansible_VPC.name}-sg"
    description = "VPC Network for Ansible training"
    vpc_id = module.Ansible_VPC.vpc_id

    ingress_cidr_blocks = ["0.0.0.0/0"]
    ingress_rules       = ["http-80-tcp", "postgresql-tcp"]

    ingress_with_source_security_group_id = [
        {
        rule = "http-80-tcp",
        source_security_group_id = module.public_subnet_ALB.security_group_id
        }
    ]

    egress_cidr_blocks = [ "0.0.0.0/0" ]
    egress_rules       = ["all-all"]

    tags = local.tags
}