resource "aws_subnet" "lab3_subnet" {
  count = length(var.subnet_cidr)
  vpc_id     = var.created_vpc_id
  cidr_block = var.subnet_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = var.subnet_name[count.index]
  }
}