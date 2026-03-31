
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}


variable "vpc_name" {
  description = "Name tag for the VPC"
  type = string
}

# variable "public_subnet_cidr" {
#   description = "CIDr block for public subnet"
#   type = string
# }

variable "availability_zone" {
  description = "AZ for the subnet"
  type = string
}

variable "subnet_cidr" {
    description = "CIDR block for the subnet"
    type = string
}


variable "private_subnet_cidr" {
    description = "CIDR block for the private subnet"
    type        = string
}