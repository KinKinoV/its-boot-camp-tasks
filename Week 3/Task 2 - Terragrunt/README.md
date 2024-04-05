# Task 2 - InfraInfrastructure provisioning with Terragrunt

Created AWS infrastructure using terragrunt. This task has 3 different environments for development, production and staging and uses simple module created by me to deploy single EC2 instance in VPC deployed for respective environment.

Each stage uses locals defined in respective terragrunt.hcl files instead of .tfvars files.

## Used Terraform modules

| Name | Version |
|------|---------|
|[terraform-aws-modules/alb/aws](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/9.8.0)|9.8.0|
|[terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.7.0)|5.7.0|
|[terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/5.1.2)|5.1.2|
|[terraform-aws-modules/autoscaling/aws](https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/7.4.1)|7.4.1|
|[terragrunt/modules/ec2](/Week%203/Task%202%20-%20Terragrunt/terragrunt/modules/ec2)|1.0.0|