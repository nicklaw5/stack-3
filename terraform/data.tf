data "aws_elb_service_account" "main" {}

# ==========================================
# == VPCs (see stack-2)
# ==========================================

data "aws_vpc" "public" {
  tags = {
    Name = "vpc-public"
  }
}

data "aws_vpc" "secure" {
  tags = {
    Name = "vpc-secure"
  }
}

data "aws_vpc" "restricted" {
  tags = {
    Name = "vpc-restricted"
  }
}

# ==========================================
# == SUBNETS (see stack-2)
# ==========================================

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.public.id

  tags = {
    Visibility = "public"
  }
}

data "aws_subnet" "public_subnet_1" {
  id     = tolist(data.aws_subnet_ids.public.ids)[0]
  vpc_id = data.aws_vpc.public.id
}

data "aws_subnet" "public_subnet_2" {
  id     = tolist(data.aws_subnet_ids.public.ids)[1]
  vpc_id = data.aws_vpc.public.id
}

data "aws_subnet" "public_subnet_3" {
  id     = tolist(data.aws_subnet_ids.public.ids)[2]
  vpc_id = data.aws_vpc.public.id
}

data "aws_subnet_ids" "secure" {
  vpc_id = data.aws_vpc.secure.id

  tags = {
    Visibility = "private"
  }
}

data "aws_subnet" "secure_subnet_1" {
  id     = tolist(data.aws_subnet_ids.secure.ids)[0]
  vpc_id = data.aws_vpc.secure.id
}

data "aws_subnet" "secure_subnet_2" {
  id     = tolist(data.aws_subnet_ids.secure.ids)[1]
  vpc_id = data.aws_vpc.secure.id
}

data "aws_subnet" "secure_subnet_3" {
  id     = tolist(data.aws_subnet_ids.secure.ids)[2]
  vpc_id = data.aws_vpc.secure.id
}

data "aws_subnet_ids" "restricted" {
  vpc_id = data.aws_vpc.restricted.id

  tags = {
    Visibility = "restricted"
  }
}

data "aws_subnet" "restricted_subnet_1" {
  id     = tolist(data.aws_subnet_ids.restricted.ids)[0]
  vpc_id = data.aws_vpc.restricted.id
}

data "aws_subnet" "restricted_subnet_2" {
  id     = tolist(data.aws_subnet_ids.restricted.ids)[1]
  vpc_id = data.aws_vpc.restricted.id
}

data "aws_subnet" "restricted_subnet_3" {
  id     = tolist(data.aws_subnet_ids.restricted.ids)[2]
  vpc_id = data.aws_vpc.restricted.id
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
