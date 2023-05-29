output "vpc_id" {
     value = aws_vpc.lab3_vpc.id 
 }

output "internet_gateway_id" {
     value = aws_internet_gateway.internet_gateway.id
 }