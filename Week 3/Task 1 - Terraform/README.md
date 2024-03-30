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

| Name | Description | Type |
|------|-------------|------|
| env  |Infrastructure environment| `string` |
| common_name | Common name prefix in infrastructure | `string` |
|------|-------------|------|
|           VPC             |
|------|-------------|------|
|vpc_cidr|CIDR for VPC| `string` |
|azs_names|List of AZ names for your region| `list(string)` |
|public_subnets_cidr|List of CIDRs for public subnets| `list(string)` |
|------|-------------|------|
|       Target Group        |
|------|-------------|------|
|health_target| Path for Target Groups to check instance's health | `string` |
|------|-------------|------|
|    Auto Scaling Group     |
|------|-------------|------|
|min_ASG_capacity|Minimal ammount of instances in Auto Scaling Group| `number` |
|max_ASG_capacity|Maximum ammount of instances in Auto Scaling Group| `number` |
|desired_ASG_capacity|Desired ammount of instances in Auto Scaling Group| `number` |

## Outputs

| Name | Description |
|------|-------------|
|ALB-dns_name| Public DNS name for created Application Load Balancer |