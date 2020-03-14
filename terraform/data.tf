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

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.private.id
}

data "aws_subnet" "private_subnet_1" {
  id     = tolist(data.aws_subnet_ids.private.ids)[0]
  vpc_id = data.aws_vpc.private.id
}

data "aws_subnet" "private_subnet_2" {
  id     = tolist(data.aws_subnet_ids.private.ids)[1]
  vpc_id = data.aws_vpc.private.id
}

data "aws_subnet" "private_subnet_3" {
  id     = tolist(data.aws_subnet_ids.private.ids)[2]
  vpc_id = data.aws_vpc.private.id
}

# ==========================================
# == AMI
# ==========================================

data "aws_ami" "ubuntu_18_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# ==========================================
# == USER DATA SCRIPT
# ==========================================

data "template_file" "user_data" {
  template = file("templates/user_data.sh")
}
