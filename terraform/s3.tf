# ==========================================
# == ACCESS LOGS BUCKET
# ==========================================

resource "aws_s3_bucket" "access_logs_bucket" {
  bucket = var.lb_logs_bucket_name
  region = var.aws_region
  acl    = "private"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.lb_logs_bucket_name}/AWSLogs/*",
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
    Name       = var.lb_logs_bucket_name
    Repository = var.repository
    ManagedBy  = var.managed_by
  }
}
