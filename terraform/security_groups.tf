resource "aws_security_group" "public_all" {
  name   = "${var.repository}-all"
  vpc_id = data.aws_vpc.public.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.repository}-all"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

resource "aws_security_group" "ec2_sg" {
  name   = "${var.repository}-ec2-sg"
  vpc_id = data.aws_vpc.secure.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      data.aws_subnet.secure_subnet_1.cidr_block,
      data.aws_subnet.secure_subnet_2.cidr_block,
      data.aws_subnet.secure_subnet_3.cidr_block,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.repository}-ec2-sg"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.repository}-rds-sg"
  vpc_id = data.aws_vpc.restricted.id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [
      data.aws_subnet.secure_subnet_1.cidr_block,
      data.aws_subnet.secure_subnet_2.cidr_block,
      data.aws_subnet.secure_subnet_3.cidr_block,
    ]
  }

  tags = {
    Name       = "${var.repository}-rds-sg"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}
