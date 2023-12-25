variable "private-subnet-ids" {}
variable "rds-security-group-ids" {}
variable "mysql_dbname" {}
resource "aws_db_subnet_group" "rds-subnet-group"{
    name = "rds-subnet-group"
    subnet_ids = var.private-subnet-ids
}
resource "aws_db_instance" "default" {
    allocated_storage = 10
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    identifier = "mydb"
    username = "dbuser"
    password = "dbpassword"
    vpc_security_group_ids = [var.rds-security-group-ids]
    db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.name
    db_name                 = var.mysql_dbname
    skip_final_snapshot     = true
    apply_immediately       = true
    backup_retention_period = 0
    deletion_protection     = false
}
