
output "vpc_id" {
  description = "The VPC ID"
  value = aws_vpc.main.id
}


output "subnet_id" {
  description = "The Subnets Id"
  value = aws_subnet.main.id
}

output "private_subnet_id" {
    description = "Private subnet ID"
    value       = aws_subnet.private.id
}