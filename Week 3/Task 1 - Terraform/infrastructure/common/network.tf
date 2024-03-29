module "AutoScaling-VPC" {
  source = "terraform-aws-modules/vpc/aws"
  version = "= 5.7.0"

  name = "${var.env}-${var.common_name}-vpc"
  cidr = var.vpc_cidr

  azs                     = var.azs_names
  public_subnets          = var.public_subnets_cidr
  map_public_ip_on_launch = true

  enable_nat_gateway = false

  default_route_table_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.AutoScaling-VPC.igw_id
    }
  ]
  tags = local.tags
}

module "AutoScaling-SG" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "= 5.1.2"

  name        = "${module.AutoScaling-VPC.name}_SG"
  description = "Security Group for EC2 Auto Scaling Group to host NodeJS container."
  vpc_id      = module.AutoScaling-VPC.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp", "all-icmp"]

  egress_cidr_blocks = [ "0.0.0.0/0" ]
  egress_rules       = ["all-all"]

  tags = local.tags
}

module "AutoScaling-ALB" {
  source  = "terraform-aws-modules/alb/aws"
  version = "= 9.8.0"

  name    = "${var.env}-${var.common_name}-ALB"
  vpc_id  = module.AutoScaling-VPC.vpc_id
  subnets = module.AutoScaling-VPC.public_subnets

  enable_deletion_protection = false

  # Security Group configs
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  # ALB configs
  ip_address_type    = "ipv4"
  load_balancer_type = "application"

  listeners = {
    http-weighted-target = {
      port             = 80
      protocol         = "HTTP"
      weighted_forward = {
        target_groups = [
          {
            target_group_key = "nodejs_tg"
            weight           = 60
          }
        ]
      }
    }
  }

  target_groups = {
    nodejs_tg = {
      name_prefix                       = "AS-tg"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      load_balancing_algorithm_type     = "weighted_random"
      load_balancing_anomaly_mitigation = "on"
      load_balancing_cross_zone_enabled = false

      health_check = {
        enabled             = true
        interval            = 30
        path                = "${var.health_target}"
        port                = 80
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version  = "HTTP1"
      create_attachment = false
    }
  }

  tags = local.tags
}