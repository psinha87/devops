variable "vpc-id" {}
variable "public-subnet-cidr" {}
output "security-group-for-python-id"{
   value =  aws_security_group.python-security-group.id
}
output "security-group-for-ssh-http"{
    value = aws_security_group.aws_security_group.id
}
output "rds-security-group"{
    value = aws_security_group.rds-security-group.id
}
resource "aws_security_group" "aws_security_group"{
    vpc_id = var.vpc-id
    dynamic "ingress"{
        for_each = local.ingress-rules
        content {
            from_port = ingress.value.port
            to_port = ingress.value.port
            cidr_blocks = ["0.0.0.0/0"]
            protocol = "tcp"
        }
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "project-security-group"
    }
}
resource "aws_security_group" "rds-security-group" {
    vpc_id = var.vpc-id
    ingress {
        from_port = 3306
        to_port = 3306
      //  cidr_blocks = var.public-subnet-cidr
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }
    tags = {
        Name= "rds-security-group"
    }
}
resource "aws_security_group" "python-security-group"{
    vpc_id = var.vpc-id
    ingress{
       from_port = 5000
        to_port = 5000
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp" 
    }
    tags = {
        Name = "python-security-group"
    }
}
