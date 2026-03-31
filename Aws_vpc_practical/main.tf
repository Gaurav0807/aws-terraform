terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# module "vpc" {
#     source = "./modules/vpc"
#     vpc_cidr = "10.0.0.0/16"
#     vpc_name = "vpc-test"
  
# }

# module "vpc" {
#     source            = "./modules/vpc"
#     vpc_cidr          = "10.0.0.0/16"
#     vpc_name          = "vpc-test"
#     subnet_cidr       = "10.0.1.0/24"
#     availability_zone = "us-east-1a"
# }

# module "server" {
#     source         = "./modules/ec2"
#     instance_name  = "test-server"
#     subnet_id      = module.vpc.subnet_id
#     vpc_id         = module.vpc.vpc_id
#     key_name       = var.key_name
#     allow_ssh_from = var.my_ip
# }


module "vpc" {
    source              = "./modules/vpc"
    vpc_cidr            = "10.0.0.0/16"
    vpc_name            = "vpc-test"
    subnet_cidr         = "10.0.1.0/24"
    private_subnet_cidr = "10.0.2.0/24"
    availability_zone   = "us-east-1a"
}

# Public server — you SSH into this from your laptop
module "server" {
    source         = "./modules/ec2"
    instance_name  = "public-server"
    subnet_id      = module.vpc.subnet_id
    vpc_id         = module.vpc.vpc_id
    key_name       = var.key_name
    allow_ssh_from = var.my_ip
}

# Private server — no public IP, only reachable from within VPC
module "private_server" {
    source         = "./modules/ec2"
    instance_name  = "private-server"
    subnet_id      = module.vpc.private_subnet_id
    vpc_id         = module.vpc.vpc_id
    key_name       = var.key_name
    allow_ssh_from = "10.0.0.0/16"
}