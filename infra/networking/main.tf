variable "vpc-cidr" {}
variable "vpc-name" {}
variable "cidr-public-subnet" {}
variable "cidr-private-subnet" {}
variable "ap-availability-zone" {}
output "project-vpc-id"{
    value =  aws_vpc.project-vpc.id
}
output "public-subnet-id"{
    value = aws_subnet.proj-public-subnet.*.id
}


resource "aws_vpc" "project-vpc" {
    cidr_block = var.vpc-cidr 
    tags = {
        Name = var.vpc-name
    }
}
resource "aws_subnet" "proj-public-subnet" {
    count = length(var.cidr-public-subnet)
    vpc_id = aws_vpc.project-vpc.id
    cidr_block =element(var.cidr-public-subnet,count.index)
    availability_zone = element(var.ap-availability-zone,count.index)
    tags = {
        Name = "proj-public-subnet-${count.index}"
    }
} 
resource "aws_subnet" "proj-private-subnet" {
    count = length(var.cidr-private-subnet)
    vpc_id = aws_vpc.project-vpc.id
    cidr_block = element(var.cidr-private-subnet,count.index)
    availability_zone = element(var.ap-availability-zone,count.index)
    tags = {
        Name = "proj-private-subnet-${count.index}"
    }
}
resource "aws_internet_gateway" "project-ig"{
    vpc_id = aws_vpc.project-vpc.id
    tags = {
        Name = "project-ig"
    }
}
resource "aws_route_table" "project-public-route-table" {
vpc_id = aws_vpc.project-vpc.id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-ig.id
}
tags = {
    Name = "project-public-route-table"
}
}
resource "aws_route_table" "project-private-route-table"{
    vpc_id = aws_vpc.project-vpc.id
   tags = {
    Name = "project-private-route-table"
}
}
resource "aws_route_table_association" "public-ip-association"{
    count = length(aws_subnet.proj-public-subnet)
    subnet_id = aws_subnet.proj-public-subnet[count.index].id
    route_table_id = aws_route_table.project-public-route-table.id
}
resource "aws_route_table_association" "private-ip-association"{
    count = length(aws_subnet.proj-private-subnet)
    subnet_id = aws_subnet.proj-private-subnet[count.index].id
    route_table_id = aws_route_table.project-private-route-table.id
}
