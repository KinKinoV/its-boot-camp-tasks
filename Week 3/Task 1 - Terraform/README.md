# Task 1 - Implementing Infrastracture using Terraform

In this task I deployed AWS EC2 Auto Scaling Group using Terraform while adhering to common conventions in structuring files and code.

## Terraform modules used

| Name | Version |
|------|---------|
|[terraform-aws-modules/alb/aws](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/9.8.0)|9.8.0|
|[terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.7.0)|5.7.0|
|[terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/5.1.2)|5.1.2|
|[terraform-aws-modules/autoscaling/aws](https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/7.4.1)|7.4.1|

## Inputs

All listed inputs are required

| Name | Description | Type | Module |
|------|-------------|------|--------|
| env  |Infrastructure environment| `string` | - |
| common_name | Common name prefix in infrastructure | `string` | - |
|vpc_cidr|CIDR for VPC| `string` | [AutoScaling-VPC](/Week%203/Task%201%20-%20Terraform/infrastructure/common/network.tf#L1) |
|azs_names|List of AZ names for your region| `list(string)` | [AutoScaling-VPC](/Week%203/Task%201%20-%20Terraform/infrastructure/common/network.tf#L1) |
|public_subnets_cidr|List of CIDRs for public subnets| `list(string)` | [AutoScaling-VPC](/Week%203/Task%201%20-%20Terraform/infrastructure/common/network.tf#L1) |
|health_target| Path for Target Groups to check instance's health | `string` | [AutoScaling-ALB](/Week%203/Task%201%20-%20Terraform/infrastructure/common/network.tf#L86) |
|min_ASG_capacity|Minimal ammount of instances in Auto Scaling Group| `number` | [NodeJS-Demoapp-AutoScalingGroup](/Week%203/Task%201%20-%20Terraform/infrastructure/common/ec2.tf#L1) |
|max_ASG_capacity|Maximum ammount of instances in Auto Scaling Group| `number` | [NodeJS-Demoapp-AutoScalingGroup](/Week%203/Task%201%20-%20Terraform/infrastructure/common/ec2.tf#L1) |
|desired_ASG_capacity|Desired ammount of instances in Auto Scaling Group| `number` | [NodeJS-Demoapp-AutoScalingGroup](/Week%203/Task%201%20-%20Terraform/infrastructure/common/ec2.tf#L1) |

## Outputs

| Name | Description |
|------|-------------|
|ALB-dns_name| Public DNS name for created Application Load Balancer |