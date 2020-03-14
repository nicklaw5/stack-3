terraform {
  backend "s3" {}
}

provider "aws" {
  version = "~> 2.53"
  region  = var.aws_region
}
