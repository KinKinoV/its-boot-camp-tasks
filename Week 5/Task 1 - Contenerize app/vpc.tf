module "Docker_VPC" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "= 5.7.0"

  name = "docker-vpc"
  cidr = var.vpc_cidr

  azs                     = var.azs
  public_subnets          = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 10)]
  database_subnets        = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 1)]
  map_public_ip_on_launch = false

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_nat_gateway = false

  default_route_table_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.Docker_VPC.igw_id
    }
  ]
  tags = local.tags
}

module "DockerVPC_SG" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "= 5.1.2"

  name        = "${module.Docker_VPC.name}-sg"
  description = "VPC Network for Docker in ECS training"
  vpc_id      = module.Docker_VPC.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "postgresql-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = local.tags
}
