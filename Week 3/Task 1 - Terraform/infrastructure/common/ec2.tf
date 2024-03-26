module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "nodejs-docker-host"

  instance_type = "t2.micro"

  tags = {
    Terraform = "true"
  }
}