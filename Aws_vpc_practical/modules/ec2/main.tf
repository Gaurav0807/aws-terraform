# Automatically find the latest Amazon Linux 2023 AMI
# No need to hardcode — this always fetches the newest one
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["al2023-ami-2023*-x86_64"]
    }

    filter { # Only pick AMIs that are available
        name   = "state"
        values = ["available"]
    }
}

# Security Group — firewall rules for this EC2
resource "aws_security_group" "instance" {
    name        = "${var.instance_name}-sg"
    description = "Security group for ${var.instance_name}"
    vpc_id      = var.vpc_id

    # Inbound: allow SSH (port 22) from your laptop only
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.allow_ssh_from]
    }

    # Outbound: allow everything # If we remove this blocks Ec2 instances tries to initiate outbounds connections but security group blocks them
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.instance_name}-sg"
    }
}


# The EC2 instance
resource "aws_instance" "main" {
    ami                    = data.aws_ami.amazon_linux.id
    instance_type          = "t2.micro"
    subnet_id              = var.subnet_id
    key_name               = var.key_name
    vpc_security_group_ids = [aws_security_group.instance.id]

    tags = {
        Name = var.instance_name
    }
}
  