variable "ami-id" {}
variable "instance-type" {}
variable "security-group-for-python-id" {}
variable "subnet-id" {}
variable "enable-public-ip-address" {}
variable "public-key" {}
output "instance-id" {
    value = aws_instance.python-terraform-server.id
}
resource "aws_instance" "python-terraform-server"{
    ami = var.ami-id
    instance_type = var.instance-type
    key_name = "mykey"
    vpc_security_group_ids = var.security-group-for-python-id
    subnet_id = var.subnet-id
    associate_public_ip_address = var.enable-public-ip-address
    user_data = "${file("./python/python-install.sh")}"
      metadata_options {
    http_endpoint = "enabled"  
    http_tokens   = "required" 
  }
  tags = {
    Name = "python-terraform-ec2"
  }
   
}
resource "aws_key_pair" "public-key"{
    key_name = "mykey"
    public_key = var.public-key
}
