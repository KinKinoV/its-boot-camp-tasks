include "autoscaling-group" {
    path = "${get_terragrunt_dir()}/../../../modules/autoscaling-group/terragrunt.hcl"
    expose = true
}

include "root" {
    path = find_in_parent_folders()
    expose = true
}

dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        public_subnets = ["mock_public_subnet1", "mock_public_subnet2"]
    }
}

dependency "alb" {
    config_path = "../alb"
    mock_outputs = {
        target_groups = {
            "nodejs_tg":{
                "arn": "fake_arn"
            }
        }
    }
}

dependency "security-group" {
    config_path = "../security-group"
    mock_outputs = {
        security_group_id = "fake_SG_id"
    }
}

inputs = merge(
    include.autoscaling-group.inputs,
    {
        vpc_zone_identifier = dependency.vpc.outputs.public_subnets

        image_id = "ami-02d7fd1c2af6eead0"
        instance_type = "t2.micro"

        network_interfaces = [
            {
                delete_on_termination = true
                description           = "eth0"
                device_index          = 0
                security_groups       = ["${dependency.security-group.outputs.security_group_id}"]
            }
        ]

        target_group_arns = [dependency.alb.outputs.target_groups["nodejs_tg"]["arn"]]

        user_data = filebase64("${get_terragrunt_dir()}/../../../../user_data/user-data.sh")
    }
)

dependencies {
    paths = ["../vpc", "../security-group", "../alb"]
}