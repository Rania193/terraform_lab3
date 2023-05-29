resource "aws_security_group" "security_group" {
  vpc_id = var.created_vpc_id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = var.egress.port
    to_port     = var.egress.port
    protocol    = var.egress.protocol
    cidr_blocks = var.egress.cidr_blocks
  }

  tags = {
    Name = var.sg_name
  }
}