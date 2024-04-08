variable "vpc_cidr" {
  description = "CIDR for Ansible VPC"
  type = string
}

variable "azs" {
  description = "List of AZs where to create subnets"
  type = list(string)
}

variable "health_target" {
  description = "Path for Target Group to check health of instances"
  type = string
}