variable "vpc-cidr" {
    type = string
    default = "10.0.0.0/16"
}
variable "vpc-name" {
    type = string
    default = "vpc-project"
}
variable "cidr-public-subnet" {
    type = list(string)
    default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable  "cidr-private-subnet" {
    type = list(string)
    default = ["10.0.3.0/24","10.0.4.0/24"]
}
variable "ap-availability-zone" {
    type = list(string)
    default = ["ap-south-1a","ap-south-1b"]
}
variable "ami-id"{
    type = string
    default = "ami-04708942c263d8190"
}
variable "instance-type"{
    type = string
    default = "t2.medium"
}
variable "enable-public-ip-address" {
    type = bool
    default = true
}

