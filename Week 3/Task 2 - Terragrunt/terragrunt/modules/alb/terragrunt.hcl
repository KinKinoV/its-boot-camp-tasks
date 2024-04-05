terraform {
    source = "tfr:///terraform-aws-modules/alb/aws?version=9.8.0"
}

locals {
    env_vars = read_terragrunt_config(find_in_parent_folders())
}

inputs = {
    name    = "${local.env_vars.locals.env}-${local.env_vars.locals.common_name}-ALB"

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
            path                = "${local.env_vars.locals.health_target}"
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

    tags = merge(
        local.env_vars.locals.tags,
        {
            Environment = local.env_vars.locals.env
        }
    )
}