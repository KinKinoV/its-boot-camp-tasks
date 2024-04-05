resource "aws_instance" "this" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.instance_subnet_id
  key_name = var.key_pair_name

  associate_public_ip_address = var.assign_public_ip

  user_data = var.user_data
  tags = var.tags
}