output "instance_id" {
    description = "EC2 instance ID"
    value       = aws_instance.main.id
}

output "public_ip" {
    description = "Public IP (useless without IGW)"
    value       = aws_instance.main.public_ip
}

output "private_ip" {
    description = "Private IP inside VPC"
    value       = aws_instance.main.private_ip
}

output "security_group_id" {
    description = "Security group ID"
    value       = aws_security_group.instance.id
}