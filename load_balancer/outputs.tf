output "lb_target_group_arn_pub" {
  value = aws_lb_target_group.lb_tg[0].arn
}

output "lb_target_group_arn_priv" {
  value = aws_lb_target_group.lb_tg[1].arn
}

output "priv_lb_dns" {
  value = aws_lb.lb[1].dns_name
}