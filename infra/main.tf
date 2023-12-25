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
    public-subnet-cidr = module.networking.public-subnet-id
}
module "python" {
    source = ".//python"
    security-group-for-python-id = [module.security-group.security-group-for-python-id,module.security-group.security-group-for-ssh-http]
    ami-id = var.ami-id
    instance-type = var.instance-type
    subnet-id = tolist(module.networking.public-subnet-id)[0]
    enable-public-ip-address = var.enable-public-ip-address
   // user-data-install-jenkins = templatefile("./jenkins/install-jenkins-with-terraform.sh", {})
    public-key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLN11osdLTzN6PHUwS4pgiGTm6fTIaeyRnzF1Cwj+mPlX0671iIvOc9wnVr5am78K+VGaWkamiYyRHF/OcR+ywtcUB1yfDiFlM2NPEMcEniOnkiOQDl6EZ6d+7JMVwjcRpHycLoWOsH6oZSNRCKK1rmfuk67nKRZdpka1EqLv3D/U3MxZaUbMmcE6sDizIc1wPCs+HQPap855U65TD+uNdveDHB4BnRjBJbBvMhCE4IxGrUXihflSPlerYj0MOQWbVnrPf6SmB1GF9+MKWV5jZKSHOg/Fqps2HLcgBVnpCwKG3BHCAz77ZBXRRMtH3lbDGX45xu9HaPyA+uPRHrpNB ec2-user@ip-172-31-28-160.eu-north-1.compute.internal"
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
    instance-id = module.jenkins.instance-id
    application-port = 5000
}
module "rds-db-instance"{
    source = ".//rds-db-instance"
    private-subnet-ids = module.networking.public-subnet-id
    rds-security-group-ids = module.security-group.rds-security-group
    mysql_dbname = "devprojdb"
}
                                             
