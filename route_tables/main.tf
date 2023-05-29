resource "aws_route_table" "route_table" {
  vpc_id = var.created_vpc_id
  route {
    cidr_block = var.the_cidr 
    gateway_id = var.the_gatway
  }
      
  tags = {
    Name = var.table_name
  }
}


resource "aws_route_table_association" "rt_assoc" {
  count = length(var.the_subnets)
  route_table_id = aws_route_table.route_table.id
  subnet_id = var.the_subnets[count.index]
}