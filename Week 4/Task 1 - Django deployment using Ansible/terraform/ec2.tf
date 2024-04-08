module "django_instances" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "= 5.6.1"

    count = 2

    name = "django-${count.index}"

    ami                    = local.ami_id
    instance_type          = "t2.micro"
    vpc_security_group_ids = [module.AnsibleVPC_SG.security_group_id]
    subnet_id              = module.Ansible_VPC.private_subnets[count.index+1]

    create_iam_instance_profile = true
    iam_role_description        = "IAM role for EC2 instance"
    iam_role_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        AmazonS3ReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }

    #user_data = filebase64("./user-data.sh")

    tags = merge(local.tags, {Ansible = "webserver"})
}

module "postgresql_instance" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "= 5.6.1"

    name = "postgres"

    ami                    = local.ami_id
    instance_type          = "t2.micro"
    vpc_security_group_ids = [module.AnsibleVPC_SG.security_group_id]
    subnet_id              = module.Ansible_VPC.private_subnets[0]

    create_iam_instance_profile = true
    iam_role_description        = "IAM role for EC2 instance"
    iam_role_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        AmazonS3ReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }

    tags = merge(local.tags, {Ansible = "postgres"})
}