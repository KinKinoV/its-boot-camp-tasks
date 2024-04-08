terraform {
  required_version = ">= 1.7.5"
  
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 5.32"
    }
  }
}

locals {
  ami_id = "ami-0cd59ecaf368e5ccf"

  tags = {
        Ansible = "true"
        Terraform = "true"
    }
}

data "aws_ami" "amzlinux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

#############################################################
#                    Ansible var files                      #
#############################################################

resource "local_file" "ansible_vars" {
  filename = "../ansible/common_vars.yml"
  content = <<-EOT
  ---
  postgres_host: ${module.postgresql_instance.private_ip}
  db_name: django_db
  db_user: django_user
  allowed_hosts: '*'
  django_dir: /usr/src/django_app
  django_port: 8000
  EOT
}