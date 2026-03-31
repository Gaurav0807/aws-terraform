
#Vpc
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}


resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true # Gives EC2 a public IP
  tags = {
    Name = "${var.vpc_name}-subnet"
  }
}


# Internet Gateway — the door from VPC to internet
# Without this, nothing can enter or leave the VPC
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.vpc_name}-igw"
    }
}

# Route Table — tells the subnet "use the IGW for internet traffic"
# 0.0.0.0/0 means "everything not inside VPC, send to IGW"
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "${var.vpc_name}-public-rt"
    }
}

# Association — link the route table to the subnet
# Without this, the subnet uses VPC's default route table (no internet)
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.main.id
    route_table_id = aws_route_table.public.id
}


# Private Subnet — no route to IGW, no public IP
# This subnet has NO route table association to the public route table
# It uses the VPC's default route table which has NO internet route
resource "aws_subnet" "private" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.private_subnet_cidr
    availability_zone       = var.availability_zone
    map_public_ip_on_launch = false

    tags = {
        Name = "${var.vpc_name}-private-subnet"
    }
}

# Elastic IP — a fixed public IP for the NAT Gateway
# NAT needs a stable IP so responses can find their way back
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

# NAT Gateway — sits in PUBLIC subnet, gives private subnet outbound internet
# Traffic flow: private EC2 → NAT (in public subnet) → IGW → internet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${var.vpc_name}-nat"
  }
}

# Private Route Table — sends internet traffic through NAT (not IGW)
#   Public route table:  0.0.0.0/0 → IGW (direct internet, two-way)
#   Private route table: 0.0.0.0/0 → NAT (outbound only)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}