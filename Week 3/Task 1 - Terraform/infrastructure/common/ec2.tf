module "NodeJS-Demoapp-AutoScalingGroup" {
  source = "terraform-aws-modules/autoscaling/aws"
  version = "= 7.4.1"

  name = "${var.env}-${var.common_name}-asg"

  min_size                  = var.min_ASG_capacity
  max_size                  = var.max_ASG_capacity
  desired_capacity          = var.desired_ASG_capacity
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.AutoScaling-VPC.public_subnets

  launch_template_name        = "${var.env}-${var.common_name}-launch_template"
  launch_template_description = "Launch templated created using Terraform for ${module.NodeJS-Demoapp-AutoScalingGroup.name}"
  update_default_version      = true

  image_id          = data.aws_ami.amzlinux.id
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
      security_groups       = ["${module.AutoScaling-SG.security_group_id}"]
    }
  ]
  
  target_group_arns = [module.AutoScaling-ALB.target_groups["nodejs_tg"]["arn"]]

  user_data = filebase64("../../user_data/user-data.sh")
}
