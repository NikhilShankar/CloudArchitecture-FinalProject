# Terraform Outputs - Display important resource information

# S3 Bucket Outputs
output "s3_bucket_names" {
  description = "Names of all S3 buckets"
  value = [
    aws_s3_bucket.bucket_1.id,
    aws_s3_bucket.bucket_2.id,
    aws_s3_bucket.bucket_3.id,
    aws_s3_bucket.bucket_4.id
  ]
}

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

# EC2 Outputs
output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "ec2_public_ip" {
  description = "Public IP address of EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of EC2 instance"
  value       = aws_instance.ec2.public_dns
}

output "ec2_ssh_command" {
  description = "SSH command to connect to EC2 instance"
  value       = "ssh -i ${var.key_pair_name}.pem ec2-user@${aws_instance.ec2.public_ip}"
}

# RDS Outputs
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_address" {
  description = "RDS instance address"
  value       = aws_db_instance.mysql.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.mysql.port
}

output "rds_database_name" {
  description = "Name of the database"
  value       = aws_db_instance.mysql.db_name
}

output "rds_connection_string" {
  description = "MySQL connection command"
  value       = "mysql -h ${aws_db_instance.mysql.address} -P ${aws_db_instance.mysql.port} -u ${var.db_username} -p ${var.db_name}"
  sensitive   = true
}

# General Information
output "aws_region" {
  description = "AWS region where resources are deployed"
  value       = var.aws_region
}

output "project_prefix" {
  description = "Project prefix used for all resources"
  value       = var.project_prefix
}
