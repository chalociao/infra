resource "aws_instance" "ubuntu" {
  count                  = length(var.subnet_cidr)
  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  key_name               = "new_instance_key"
  subnet_id              = aws_subnet.fra_vpc_subnet[count.index].id
  security_groups        = [
    "${aws_security_group.fra_vpc_sg.id}"
  ]
  tags = {
    Name = "private_ubuntu"
  }
}
