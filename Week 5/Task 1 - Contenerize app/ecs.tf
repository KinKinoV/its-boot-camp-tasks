module "ecs-cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "= 5.11.1"

  cluster_name = "sample-django_in-ecs"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 1
        base   = 0
      }
    }
  }

  tags = local.tags
}

module "ecs-service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "= 5.11.1"

  name        = "sample-docker"
  cluster_arn = module.ecs-cluster.arn

  cpu    = 1024
  memory = 2048

  enable_execute_command = false
  assign_public_ip       = true

  desired_count = 2

  enable_autoscaling = true


  container_definitions = {
    sample-django = {
      cpu    = 512
      memory = 1024

      image     = var.docker_image
      essential = true

      port_mappings = [
        {
          name          = "sampdjang-80"
          containerPort = var.container_port
        }
      ]
      entrypoint               = ["sh", "-c"]
      command                  = ["python3 manage.py collectstatic && python3 manage.py makemigrations && python3 manage.py migrate && python3 manage.py runserver 0.0.0.0:${var.container_port}"]
      readonly_root_filesystem = false
      environment = [
        {
          name  = "DATABASE_URL"
          value = "postgres://${var.db_user}:${var.db_password}@${module.postgres_DB.db_instance_address}/${var.db_name}"
        },
        {
          name  = "DJANGO_ALLOWED_HOSTS"
          value = "*"
        }
      ]

      enable_cloudwatch_logging = true
    }
  }

  security_group_ids = [module.DockerVPC_SG.security_group_id]
  subnet_ids         = module.Docker_VPC.public_subnets

  load_balancer = {
    service = {
      container_name   = "sample-django"
      container_port   = var.container_port
      target_group_arn = module.Docker-ALB.target_groups["docker_tg"]["arn"]
    }
  }
}
