module "postgres_DB" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.5.4"

  identifier = "django-postgres"

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14"
  major_engine_version = "14"
  instance_class       = "db.t3.micro"

  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 40

  db_name  = var.db_name
  username = var.db_user
  password = var.db_password
  port     = var.db_port

  manage_master_user_password = false
  multi_az                    = false
  db_subnet_group_name        = module.Docker_VPC.database_subnet_group
  vpc_security_group_ids      = [module.DockerVPC_SG.security_group_id]

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

}
