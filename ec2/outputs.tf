output "private_key" {
  value     = tls_private_key.tls_priv_key.private_key_pem
  sensitive = true
}

output "public_ec2_1" {
  value = aws_instance.public_ec2[0].id
}

output "public_ec2_2" {
  value = aws_instance.public_ec2[1].id
}


output "priv_ec2_1" {
  value = aws_instance.private_ec2[0].id
}

output "priv_ec2_2" {
  value = aws_instance.private_ec2[1].id
}