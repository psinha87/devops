output "target-group-arn" {
    value = aws_lb_target_group.python-target-group.arn
}

variable "vpc-id" {}
variable "instance-id" {}
resource "aws_lb_target_group" "python-target-group" {
    name = "python-target-group"
    port = 5000
    protocol = "HTTP"
    vpc_id = var.vpc-id
      health_check {
    path = "/login"
    port = 5000
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}
resource "aws_lb_target_group_attachment" "python-association"{
    target_group_arn = aws_lb_target_group.python-target-group.arn
    target_id = var.instance-id
    port = 5000
}