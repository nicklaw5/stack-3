resource "aws_acm_certificate" "demo_cert" {
  private_key       = file("certificates/privkey.pem")
  certificate_body  = file("certificates/cert.pem")
  certificate_chain = file("certificates/fullchain.pem")

  tags = {
    Name       = "${var.repository}-demo-cert"
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}
