
variable "aws_region" {
  description = "Aws Region"
  type = string
  default = "us-east-1"
}

variable "key_name" {
  description = "SSH key pair name"
  type = string
}

variable "my_ip" {
  description = "Your laptop IP in CIDR (e.g. 106.219.121.1/32)"
  type = string
}