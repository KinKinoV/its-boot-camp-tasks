# ======================== Environment and Naming =====================
variable "env" {
  description = "Infrastructure environment"
  type = string
}

variable "common_name" {
  description = "Common name prefix in infrastructure"
  type = string
}

# ================================ VPC ================================
variable "vpc_cidr" {
    description = "CIDR for VPC"
    type = string
}

variable "azs_names" {
  description = "List of AZ names for your region"
  type = list(string)
}

variable "public_subnets_cidr" {
  description = "List of CIDRs for public subnets"
  type = list(string)
}

# ============================ Target Group ============================
variable "health_target" {
  description = "Path for Target Groups to check instance's health."
  type = string
}

# ========================= Auto Scaling Group =========================
variable "min_ASG_capacity" {
  description = "Minimal ammount of instances in Auto Scaling Group"
  type = number
}

variable "max_ASG_capacity" {
  description = "Maximum ammount of instances in Auto Scaling Group"
  type = number
}

variable "desired_ASG_capacity" {
  description = "Desired ammount of instances in Auto Scaling Groupe"
  type = number
}