resource "aws_route53_zone" "demo_zone" {
  name = "demo.nicholaslaw.com.au"

  tags = {
    Name       = "${var.repository}-demo-zone"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}

resource "aws_route53_record" "demo_a_record" {
  zone_id = aws_route53_zone.demo_zone.zone_id
  name    = "demo.nicholaslaw.com.au"
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }

  # Here we wait for the ASG, NLB and ALB to complete creation before attempting
  # to assign an A record with a value that points to the public-facing ALB.
  depends_on = [
    aws_lb.app_alb,
    aws_lb.app_nlb,
    aws_autoscaling_group.asg,
  ]
}

resource "aws_route53_record" "demo_db_record" {
  zone_id = aws_route53_zone.demo_zone.zone_id
  name    = "db.demo.nicholaslaw.com.au"
  type    = "CNAME"
  records = [aws_db_instance.rds.address]
  ttl     = 300

  # Here we wait for the RDS instance to be ready so we can retreive it's address.
  depends_on = [aws_db_instance.rds]
}
