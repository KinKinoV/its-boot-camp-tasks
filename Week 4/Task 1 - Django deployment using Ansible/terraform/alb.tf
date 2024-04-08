module "public_subnet_ALB" {
    source = "terraform-aws-modules/alb/aws"
    version = "= 9.8.0"

    name = "ansible-alb"
    vpc_id = module.Ansible_VPC.vpc_id
    subnets = module.Ansible_VPC.public_subnets

    enable_deletion_protection = false

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

    ip_address_type    = "ipv4"
    load_balancer_type = "application"

    listeners = {
        http-weighted-target = {
            port             = 80
            protocol         = "HTTP"
            weighted_forward = {
                target_groups = [
                    {
                        target_group_key = "django_tg"
                        weight           = 60
                    }
                ]
            }
        }
    }

    target_groups = {
        django_tg = {
            name_prefix                       = "dj"
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

resource "aws_lb_target_group_attachment" "django" {
  count = 2
  target_group_arn = module.public_subnet_ALB.target_groups["django_tg"]["arn"]
  target_id = module.django_instances[count.index].id
  port = 80

  depends_on = [module.public_subnet_ALB, module.django_instances]
}