# Task 1 - Transition to Contenerized Environment for a Client

In this task I contenerized [sample-django](https://github.com/digitalocean/sample-django) app and deployed created image to AWS Elastic Container Services.

## Docker image

Used [Dockerfile](https://github.com/KinKinoV/sample-django-docker/blob/main/Dockerfile) is located in fork [sample-django-docker](https://github.com/KinKinoV/sample-django-docker). For creating this image I used python:3.8-alpine base image for it's small size and did multi-stage build to further decrease size of the image. Created image is available publicly in DockerHub([link](https://hub.docker.com/layers/kinkinov/training/sample-django/images/sha256-72f19abfe4794e4f7487136a4cb4b74f91402d3e7715dd9118973f92e0980499?context=repo)).

## Terraform
### Modules Used

| Name | Version |
|------|---------|
|[terraform-aws-modules/alb/aws](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/9.8.0)|9.8.0|
|[terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.7.0)|5.7.0|
|[terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/5.1.2)|5.1.2|
|[terraform-aws-modules/ecs/aws](https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/5.11.0)|5.11.0|
|[terraform-aws-modules/rds/aws](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/6.5.4)|6.5.4|

### Inputs

All listed inputs are required

| Name | Description | Type | Module |
|------|-------------|------|--------|
| vpc_cidr | CIDR for Ansible VPC | `string` | [Docker_VPC](/Week%205/Task%201%20-%20Contenerize%20app/vpc.tf#L6) |
| azs | List of AZs where to create subnets | `list(string)` | [Docker_VPC](/Week%205/Task%201%20-%20Contenerize%20app/vpc.tf#L8) |
| health_target | Path for Target Group to check health of instances | `string` | [Docker-ALB](/Week%205/Task%201%20-%20Contenerize%20app/alb.tf#L60) |
| docker_image | Tag of the Docker image to use | `string` | [ecs-service](/Week%205/Task%201%20-%20Contenerize%20app/ecs.tf#L42) |
| container_port | Port for the container to listen on | `number` | [ecs-service](/Week%205/Task%201%20-%20Contenerize%20app/ecs.tf#L48) |
| db_name | Name of the database to be created | `string` | [postgres_DB](/Week%205/Task%201%20-%20Contenerize%20app/rds.tf#L17) |
| db_user | Username for newly created user of DB | `string` | [postgres_DB](/Week%205/Task%201%20-%20Contenerize%20app/rds.tf#L18) |
| db_port | Port on which DB should listen for connections | `string` | [postgres_DB](/Week%205/Task%201%20-%20Contenerize%20app/rds.tf#L20) |
| db_password | Password for the database | `string`, sensitive:`true` | [postgres_DB](/Week%205/Task%201%20-%20Contenerize%20app/rds.tf#L19) |

### Outputs

| Name | Description |
|------|-------------|
| alb_dns | DNS name of the created DB |
| db_instance_address | DNS name of the RDS for the django application |
