# Project Configuration Variables
variable "project_prefix" {
  description = "Prefix for all resource names - change in terraform.tfvars"
  type        = string
  default     = "cloudinfra-finalproject-terra-9026254"
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

# Network Configuration Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet (EC2)"
  type        = string
  default     = "10.1.1.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1 (RDS)"
  type        = string
  default     = "10.1.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2 (RDS)"
  type        = string
  default     = "10.1.4.0/24"
}

# EC2 Configuration Variables
variable "instance_type" {
  description = "EC2 instance type - configurable for different workloads"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Name of existing EC2 key pair for SSH access"
  type        = string
  # No default - must be provided in terraform.tfvars
}

# RDS Configuration Variables
variable "db_name" {
  description = "Name of the MySQL database to create"
  type        = string
  default     = "myappdatabase"
}

variable "db_username" {
  description = "Master username for RDS database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for RDS database - keep secure!"
  type        = string
  sensitive   = true
  # No default - must be provided in terraform.tfvars
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
  default     = 20
}
