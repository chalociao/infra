# Create VPC
resource "aws_vpc" "fra_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.dns_support 
  enable_dns_hostnames = var.dns_hostnames
  instance_tenancy     = var.instance_ten
  tags = {
    Name = "Frankfurt VPC"
  }
}
