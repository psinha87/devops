variable "security-group-ssh-http" {}
variable "subnet-id" {}
variable "target-group-arn" {}
variable "instance-id" {}
variable "application-port" {}
resource "aws_lb" "project-lb"{
    name = "python-project-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [var.security-group-ssh-http]
    subnets = var.subnet-id
    enable_deletion_protection = false
}
resource "aws_lb_target_group_attachment" "lb-target-group-attachment"{
    target_group_arn = var.target-group-arn
    target_id = var.instance-id 
    port = var.application-port
}
resource "aws_lb_listener" "python-listener"{
    load_balancer_arn = aws_lb.project-lb.arn
    port = 5000
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = var.target-group-arn
    }
}

