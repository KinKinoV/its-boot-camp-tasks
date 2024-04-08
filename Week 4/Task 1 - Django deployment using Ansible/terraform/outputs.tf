output "vpc_id" {
  value = module.Ansible_VPC.vpc_id
}

output "private_subnets" {
  value = module.Ansible_VPC.private_subnets
}

output "nat_gateways_public_ip" {
  value = module.Ansible_VPC.nat_public_ips
}

output "ALB_DNS" {
  value = module.public_subnet_ALB.dns_name
}