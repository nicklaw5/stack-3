data "aws_elb_service_account" "main" {}

# ==========================================
# == VPCs (see stack-2)
# ==========================================

data "aws_vpc" "public" {
  tags = {
    Name       = "public-vpc"
    Visibility = "public"
  }
}

data "aws_vpc" "private" {
  tags = {
    Name       = "private-vpc"
    Visibility = "private"
  }
}

# ==========================================
# == SUBNETS (see stack-2)
# ==========================================

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.public.id
}
