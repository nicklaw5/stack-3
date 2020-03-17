resource "aws_db_subnet_group" "rds" {
  name = "${var.repository}-rds-subnet-group"

  subnet_ids = [
    data.aws_subnet.restricted_subnet_1.id,
    data.aws_subnet.restricted_subnet_2.id,
    data.aws_subnet.restricted_subnet_3.id,
  ]

  tags = {
    Name       = "${var.repository}-rds-subnet-group"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.5"
  instance_class         = "db.t2.micro"
  name                   = "${replace(var.repository, "-", "")}rdsinstance"
  identifier             = "${replace(var.repository, "-", "")}rdsinstance"
  username               = "postgres"
  password               = "postgres"
  parameter_group_name   = "default.postgres11"
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name       = "${var.repository}-rds-instance"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}
