# VPC private subnet
resource "aws_subnet" "fra_vpc_subnet" {
  count             = length(var.subnet_cidr)
  vpc_id            = aws_vpc.fra_vpc.id
  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "Frankfurt VPC Subnet"
  }
}

# Route table
resource "aws_route_table" "fra_vpc_route_table" {
  count = length(var.subnet_cidr)
  vpc_id = aws_vpc.fra_vpc.id
  tags = {
    Name = "Frankfurt VPC Route Table"
  }
}

resource "aws_route" "fra_vpc_private_route" {
  count = length(var.subnet_cidr)
  route_table_id         = aws_route_table.fra_vpc_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  instance_id = aws_instance.ubuntu[count.index].id
}

# Associate route table with subnet
resource "aws_route_table_association" "fra_vpc_association"{
  count = length(var.subnet_cidr)
  subnet_id = aws_subnet.fra_vpc_subnet[count.index].id
  route_table_id = aws_route_table.fra_vpc_route_table[count.index].id
}

# Security Group
resource "aws_security_group" "fra_vpc_sg" {
  vpc_id       = aws_vpc.fra_vpc.id
  
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
   Name = "Frankfurt VPC Security Group"
  }
}
