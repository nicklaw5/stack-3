# ==========================================
# == NETWORK LOAD BALANCER
# ==========================================

resource "aws_lb" "app_nlb" {
  name               = "${var.repository}-app-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.private.ids

  # access_logs {
  #   bucket  = aws_s3_bucket.access_logs_bucket.bucket
  #   enabled = true
  # }

  tags = {
    Name       = "${var.repository}-app-nlb"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

# ==========================================
# == NLB TARGET GROUP
# ==========================================

resource "aws_lb_target_group" "app_nlb_tg" {
  vpc_id   = data.aws_vpc.private.id
  name     = "${var.repository}-app-nlb-tg"
  port     = 80
  protocol = "HTTP"

  tags = {
    Name       = "${var.repository}-app-nlb-tg"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}
