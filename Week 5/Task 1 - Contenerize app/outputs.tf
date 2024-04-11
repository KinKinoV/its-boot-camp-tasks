output "alb_dns" {
  value = module.Docker-ALB.dns_name
}

output "db_instance_address" {
  value = module.postgres_DB.db_instance_address
}
