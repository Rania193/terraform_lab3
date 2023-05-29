output "pub_id_1" {
    value = aws_subnet.lab3_subnet[0].id
  
}

output "pub_id_2" {
    value = aws_subnet.lab3_subnet[1].id
  
}

output "priv_id_1" {
    value = aws_subnet.lab3_subnet[2].id
  
}

output "priv_id_2" {
    value = aws_subnet.lab3_subnet[3].id
  
}