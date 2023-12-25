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
    public-key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCOc3jYzQaIuFNs9pl7N/kcfmWPgyhitrUHVbwaZlkajftbXNgEtxkoBKhb9bLpXCUKc29cIoX3skgVkTijMVzU6rVioL/f/tpd5X+LBCzlB6YyAfarmVwukK2+3rGqNt2/3ezJ7Tgy5p/HeTTTJ/wymt67Zrn6W03wh+yfFxYXoLjCPY7nCFoKjaIhgx9P+QJkene7toOZmkQ+ogTt014sRlBppNFSzZcwvYUqNjpMtu1VQ+f+iIUpWVefUoWVAt3cvrzSpTxwrv9kTJjOhUeaaAc9vNBGMVI5PX2T1oz/Qhvnr+71fD0KmAN4wp7SQUw1+4cjje5BM118c1v1gJBnfcA1kf1UWqzlXaX23FkUqyjvvmZtsGbTd+gFHGuYla2ky/Tw6S47I6fcWshwoGoBRILx39igUB1vAaYN7Q3iRMw1xS8cHmx1g2wTqYO6ULJ6IrA4pj9mTemg+/CHygmBy1wEa76k4zVwTqVAQGntY/3OelEVWE4ePZ/Z2aOTOuc= ec2-user@ip-172-31-28-160.eu-north-1.compute.internal"
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
                                             
