variable "ami" {
  description = "AMI id for the instance OS"
  type = string
}

variable "instance_type" {
  description = "Instance type for the EC2 (default: 't2.micro')"
  type = string
  default = "t2.micro"
}

variable "instance_subnet_id" {
  description = "ID of sybnet where to place EC2 instance"
  type = string
}

variable "key_pair_name" {
  description = "Name of already existing Key Pair in AWS to use with this instance"
  type = string
  default = null
}

variable "assign_public_ip" {
  description = "Should be public IP assigned to instance"
  type = bool
  default = false
}

variable "user_data" {
  description = "Base64 encoded string of user-data.sh"
  type = string
  default = null
}

variable "tags" {
  description = "Tags to add to instance"
  type = map(string)
  default = {
    Terraform = true
    Name = "my-instance"
  }
}