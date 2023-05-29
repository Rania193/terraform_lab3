resource "aws_lb" "lb" {
  count =  length(var.lb_name)
  name               = var.lb_name[count.index]
  internal           = var.internal_or[count.index]
  load_balancer_type = var.lb_type
  security_groups    = [var.lb_sg[count.index]]
  subnets            =  count.index == 0 ? var.public_subnets : var.private_subnets



  tags = {
    Environment = var.lb_env[count.index]
  }
}   

resource "aws_lb_target_group" "lb_tg" {
  count = length(var.tg_name)
  name     = var.tg_name[count.index]
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.created_vpc_id
}

resource "aws_lb_listener" "lb_l" {
  count = length(var.lb_name)
  load_balancer_arn = aws_lb.lb[count.index].arn
  port              = var.tg_port
  protocol          = var.tg_protocol
  default_action {
    type             = var.default_action_type
    target_group_arn = aws_lb_target_group.lb_tg[count.index].arn
  }
}