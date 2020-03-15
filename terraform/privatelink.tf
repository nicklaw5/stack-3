resource "aws_vpc_endpoint_service" "app" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.app_nlb.arn]

  tags = {
    Name       = "${var.repository}-endpoint-service"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

resource "aws_vpc_endpoint" "app" {
  vpc_id             = data.aws_vpc.public.id
  auto_accept        = true
  service_name       = aws_vpc_endpoint_service.app.service_name
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.public_all.id]

  subnet_ids = [
    data.aws_subnet.public_subnet_1.id,
    data.aws_subnet.public_subnet_2.id,
    data.aws_subnet.public_subnet_3.id,
  ]

  tags = {
    Name       = "${var.repository}-endpoint"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}
