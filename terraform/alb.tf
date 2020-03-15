# ==========================================
# == APPLICATION LOAD BALANCER
# ==========================================

resource "aws_lb" "app_alb" {
  name               = "${var.repository}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_all.id]
  subnets            = data.aws_subnet_ids.public.ids

  tags = {
    Name       = "${var.repository}-app-alb"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

# ==========================================
# == ALB LISTENER
# ==========================================

resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_tg.arn
  }
}

# ==========================================
# == ALB TARGET GROUP
# ==========================================

resource "aws_lb_target_group" "app_alb_tg" {
  vpc_id      = data.aws_vpc.public.id
  name        = "${var.repository}-app-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  tags = {
    Name       = "${var.repository}-app-alb"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

data "aws_network_interface" "net_1" {
  id = tolist(aws_vpc_endpoint.app.network_interface_ids)[0]
}

data "aws_network_interface" "net_2" {
  id = tolist(aws_vpc_endpoint.app.network_interface_ids)[1]
}

data "aws_network_interface" "net_3" {
  id = tolist(aws_vpc_endpoint.app.network_interface_ids)[2]
}

resource "aws_lb_target_group_attachment" "app_alb_tg_att_net_1" {
  target_group_arn = aws_lb_target_group.app_alb_tg.arn
  target_id        = data.aws_network_interface.net_1.private_ip
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_alb_tg_att_net_2" {
  target_group_arn = aws_lb_target_group.app_alb_tg.arn
  target_id        = data.aws_network_interface.net_2.private_ip
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_alb_tg_att_net_3" {
  target_group_arn = aws_lb_target_group.app_alb_tg.arn
  target_id        = data.aws_network_interface.net_3.private_ip
  port             = 80
}
