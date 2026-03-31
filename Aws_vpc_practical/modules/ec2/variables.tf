
variable "instance_name" {
  description = "Name tag for the EC2 instances"
  type = string
}

variable "subnet_id" {
  description = "Subnet ID to launch"
  type = string
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type = string
}

variable "key_name" {
  description = "SSH key pair name"
  type = string
}

variable "allow_ssh_from" {
  description = "Your laptop IP"
  type = string
}
