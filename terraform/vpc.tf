# VPC and Networking Resources

# Get available AZs in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Main VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_prefix}-vpc"
  }
}

# Internet Gateway for public internet access
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_prefix}-igw"
  }
}

# Public subnet for EC2 instance
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_prefix}-public-subnet"
    Type = "Public"
  }
}

# Private subnet 1 for RDS (first AZ)
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_prefix}-private-subnet-1"
    Type = "Private"
  }
}

# Private subnet 2 for RDS (second AZ for redundancy)
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_prefix}-private-subnet-2"
    Type = "Private"
  }
}

# Route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Route all traffic to internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_prefix}-public-rt"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security group for EC2 - allows SSH access
resource "aws_security_group" "ec2" {
  name        = "${var.project_prefix}-ec2-sg"
  description = "Security group for EC2 instance - allows SSH"
  vpc_id      = aws_vpc.main.id

  # Allow SSH from anywhere (for demo purposes)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.project_prefix}-ec2-sg"
  }
}

# Security group for RDS - allows MySQL access
resource "aws_security_group" "rds" {
  name        = "${var.project_prefix}-rds-sg"
  description = "Security group for RDS instance - allows MySQL"
  vpc_id      = aws_vpc.main.id

  # Allow MySQL from anywhere (for demo purposes)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow MySQL access"
  }

  # Allow MySQL from EC2 security group
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
    description     = "Allow MySQL from EC2"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.project_prefix}-rds-sg"
  }
}

# DB subnet group for RDS - spans multiple AZs
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_prefix}-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "${var.project_prefix}-db-subnet-group"
  }
}
