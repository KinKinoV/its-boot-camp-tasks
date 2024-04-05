terraform {
    source = "tfr:///terraform-aws-modules/autoscaling/aws?version=7.4.1"
}

locals {
    env_vars = read_terragrunt_config(find_in_parent_folders())
}

inputs = {
    name = "${local.env_vars.locals.env}-${local.env_vars.locals.common_name}-asg"

    min_size                  = local.env_vars.locals.min_ASG_capacity
    max_size                  = local.env_vars.locals.max_ASG_capacity
    desired_capacity          = local.env_vars.locals.desired_ASG_capacity
    wait_for_capacity_timeout = 0
    health_check_type         = "EC2"

    launch_template_name        = "${local.env_vars.locals.env}-${local.env_vars.locals.common_name}-launch_template"
    launch_template_description = "Launch templated created using Terraform."
    update_default_version      = true

    image_id          = "ami-02d7fd1c2af6eead0"
    instance_type     = "t2.micro"
    ebs_optimized     = false
    enable_monitoring = false

    block_device_mappings = [
        {
        device_name = "/dev/xvda"
        no_device   = 0
        ebs         = {
            delete_on_termination = true
            encrypted             = false
            volume_size           = 8
            volume_type           = "gp2"
        }
        }
    ]

    metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 1
    }

    network_interfaces = [
        {
            delete_on_termination = true
            description           = "eth0"
            device_index          = 0
            security_groups       = ["fake_SG"]
        }
    ]
    
    target_group_arns = ["fake_arn"]

    scaling_policies = {
        avg_cpu_more_50 = {
        policy_type = "TargetTrackingScaling"
        estimated_instance_warmup = 300
        target_tracking_configuration = {
            predefined_metric_specification = {
            predefined_metric_type = "ASGAverageCPUUtilization"
            }
            target_value = 50.0
        }
        }
    }
}