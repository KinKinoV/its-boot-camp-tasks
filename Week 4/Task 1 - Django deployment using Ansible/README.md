# Task 1 - Django deployment using Ansible

In this task I created needed infrastructure to deploy Djnago app [sample-django](https://github.com/digitalocean/sample-django) and configured EC2 instances using Ansible.

# Ansible

Made 3 playbooks (webservers.yml, db.yml, deploy.yml) that are using roles to configure remote nodes.
Roles created:
  1. [webservers-setup](/Week%204/Task%201%20-%20Django%20deployment%20using%20Ansible/ansible/roles/webserver-setup/README.md)
  2. [postgres-setup](/Week%204/Task%201%20-%20Django%20deployment%20using%20Ansible/ansible/roles/postgres-setup/README.md)
  3. [deploy](/Week%204/Task%201%20-%20Django%20deployment%20using%20Ansible/ansible/roles/deploy/README.md)

# Terraform
## Modules Used

| Name | Version |
|------|---------|
|[terraform-aws-modules/alb/aws](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/9.8.0)|9.8.0|
|[terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.7.0)|5.7.0|
|[terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/5.1.2)|5.1.2|
|[terraform-aws-modules/ec2-instance/aws](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/5.6.1)|5.6.1|

## Inputs

All listed inputs are required

| Name | Description | Type | Module |
|------|-------------|------|--------|
| vpc_cidr | CIDR for Ansible VPC | `string` | [Ansible_VPC](/Week%204/Task%201%20-%20Django%20deployment%20using%20Ansible/terraform/vpc.tf#L6) |
| azs | List of AZs where to create subnets | `list(string)` | [Ansible_VPC](/Week%204/Task%201%20-%20Django%20deployment%20using%20Ansible/terraform/vpc.tf#L8) |
| health_target | Path for Target Group to check health of instances | `string` | [public_subnet_ALB](/Week%204/Task%201%20-%20Django%20deployment%20using%20Ansible/terraform/alb.tf#L58) |

## Outputs

| Name | Description |
|------|-------------|
|vpc_id| ID of created VPC |
|private_subnets| List of created private subnets |
|nat_gateways_public_ip| List of public ips for NAT gateways |
|ALB_DNS| Public DNS for Application Load Balancer |