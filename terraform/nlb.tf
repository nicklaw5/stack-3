# ==========================================
# == NETWORK LOAD BALANCER
# ==========================================

resource "aws_lb" "app_nlb" {
  name               = "${var.repository}-app-nlb"
  internal           = true
  load_balancer_type = "network"

  subnets = [
    data.aws_subnet.secure_subnet_1.id,
    data.aws_subnet.secure_subnet_2.id,
    data.aws_subnet.secure_subnet_3.id,
  ]

  tags = {
    Name       = "${var.repository}-app-nlb"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

# ==========================================
# == NLB LISTENER
# ==========================================

resource "aws_lb_listener" "app_nlb_listener_443" {
  load_balancer_arn = aws_lb.app_nlb.arn
  port              = 443
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06" # TLS 1.2 minimum required
  certificate_arn   = aws_acm_certificate.demo_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_nlb_tg.arn
  }
}

# ==========================================
# == NLB TARGET GROUP
# ==========================================

resource "aws_lb_target_group" "app_nlb_tg" {
  vpc_id   = data.aws_vpc.secure.id
  name     = "${var.repository}-app-nlb-tg"
  port     = 80
  protocol = "TCP"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name       = "${var.repository}-app-nlb-tg"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}
