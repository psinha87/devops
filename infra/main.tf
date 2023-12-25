provider "aws"{
    region = "ap-south-1"
}
module "networking"{
    source = ".//networking"
    vpc-cidr = var.vpc-cidr
    vpc-name = var.vpc-name
    cidr-public-subnet = var.cidr-public-subnet
    cidr-private-subnet = var.cidr-private-subnet
    ap-availability-zone = var.ap-availability-zone
}
module "security-group"{
    source = ".//security-group"
    vpc-id = module.networking.project-vpc-id
    //public-subnet-cidr = tolist(module.networking.public-subnet-id)
}
module "python" {
    source = ".//python"
    security-group-for-python-id = [module.security-group.security-group-for-python-id,module.security-group.security-group-for-ssh-http]
    ami-id = var.ami-id
    instance-type = var.instance-type
    subnet-id = tolist(module.networking.public-subnet-id)[0]
    enable-public-ip-address = var.enable-public-ip-address
   // user-data-install-jenkins = templatefile("./jenkins/install-jenkins-with-terraform.sh", {})
    public-key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCoMZ4VzjPSy8isCQFHZTOIGz7o9BjdTsISthbKBRFBvxYdXnTkbphTLOnd5l9CjtWaCFGEReatIFRbtgOH9ArQkr27Wln9hbl24n7Z8W9t4efhrBLBxvvOb9fdwyJe143UQDlbM0NOVE2/ogd00un0iUAYc5OEcZBjPYef1GXBVN+uYzx5PVkEboZj8hZsp2FrSA385fcH+IBxLVzk3NlUbdgpf2iEJyOXagu4X65bhWE9v0ph6YpRCXZvfWSvE0x4wtKumhvuZDARsx7B3Ig6AVKHowU6V4Q35rmY4KmO/YmNs+1xjFGt1kIh4wRjs74FbOo8cQYlW/uVnrXQbfA9WvyTvOXQWArZBv86dDjzBHcmA/h5/copvxmyALXMZ+nugEEaBStPOAOy4AU/ippuQ0UdQeEPEaSQcW4Q7QqR2KPb4BfbqNuyUXFrjCxaAQm0yS5U46aSsIi6FXAxwqgZxeCfP2geMl8q8RkcD9AZKTs7zrZA0cbfSXaiiZ5qxeE= ec2-user@ip-172-31-28-160.eu-north-1.compute.internal"
}
module "lb-target-group"{
    source = ".//lb_target_group"
    instance-id = module.python.instance-id
    vpc-id = module.networking.project-vpc-id

}
module "load-balancer"{
    source = ".//load-balancer"
    security-group-ssh-http = module.security-group.security-group-for-ssh-http
    subnet-id = module.networking.public-subnet-id
    target-group-arn = module.lb-target-group.target-group-arn
    instance-id = module.python.instance-id
    application-port = 5000
}
module "rds-db-instance"{
    source = ".//rds-db-instance"
    private-subnet-ids = tolist(module.networking.public-subnet-id)
    rds-security-group-ids = module.security-group.rds-security-group
    mysql_dbname = "devprojdb"
}
                                             
