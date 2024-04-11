#################################################################
#                           VPC                                 #
#################################################################

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "azs" {
  description = "List of AZS where VPC will create subnets"
  type        = list(string)
}

#################################################################
#                  Application Load Balancer                    #
#################################################################

variable "health_target" {
  description = "Path for Target Group to check health of ECS node"
  type        = string
}

#################################################################
#                  Elastic Container Services                   #
#################################################################

variable "docker_image" {
  description = "Tag of the Docker image to use"
  type        = string
}

variable "container_port" {
  description = "Port for the container to listen on"
  type        = number
}

#################################################################
#                           RDS                                 #
#################################################################

variable "db_name" {
  description = "Name of the database to be created"
  type        = string
}

variable "db_user" {
  description = "Username for newly created user of DB"
  type        = string
}

variable "db_port" {
  description = "Port on which DB should listen for connections"
  type        = string
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}
