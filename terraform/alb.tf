# ==========================================
# == ACCESS LOGS BUCKET
# ==========================================

resource "aws_s3_bucket" "alb_access_logs" {
  bucket = var.alb_logs_bucket_name
  acl    = "private"
  region = var.aws_region

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.alb_logs_bucket_name}/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY

  tags = {
    Name       = var.alb_logs_bucket_name
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

# ==========================================
# == ALB SECURITY GROUP
# ==========================================

resource "aws_security_group" "alb_sg" {
  name        = "${var.repository}-alb-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = data.aws_vpc.public.id

  ingress {
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "HTTPS traffic"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.private.cidr_block]
  }

  tags = {
    Name       = "${var.repository}-alb-sg"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

# ==========================================
# == APPLICATION LOAD BALANCER
# ==========================================

resource "aws_lb" "app" {
  name               = "${var.repository}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnet_ids.public.ids

  access_logs {
    bucket  = aws_s3_bucket.alb_access_logs.bucket
    enabled = true
  }

  tags = {
    Name       = "${var.repository}-app-alb"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}
