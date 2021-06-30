# VPC for public VM
resource "aws_vpc" "pub_vpc" {
  cidr_block           = var.pub_cidr_block
  enable_dns_support   = var.dns_support 
  enable_dns_hostnames = var.dns_hostnames
  instance_tenancy     = var.instance_ten
}

# Public subnet for KOPS instance
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.pub_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = var.subnet_public_ip
  tags = {
    Name  = "Public subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.pub_vpc.id
  tags = {
    Name  = "Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.pub_vpc.id
  route {
    cidr_block = var.public_rt_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name  = "Public subnet route table"
  }
}

resource "aws_route_table_association" "rt_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "pub_vpc_sg" {
  vpc_id       = aws_vpc.pub_vpc.id
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = ["0.0.0.0/0"]  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 
  
  # allow egress of all ports
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  tags = {
   Name = "Public VPC Security Group"
  }
}

# IAM Role for KOPS EC2
resource "aws_iam_role" "kops_ec2_access_role" {
  name               = "kops_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name  = "ec2_profile"                         
  role = aws_iam_role.kops_ec2_access_role.name
}

# Create IAM Policy
resource "aws_iam_role_policy" "ec2_policy" {
  name        = "ec2_policy"
  role        = aws_iam_role.kops_ec2_access_role.id
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_instance" "kops" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  key_name                    = "public_kops_instance"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups             = [
    "${aws_security_group.pub_vpc_sg.id}"
  ]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "public_kops"
  }
}
