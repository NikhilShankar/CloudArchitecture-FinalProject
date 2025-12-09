# RDS MySQL Database Configuration

# MySQL RDS instance
resource "aws_db_instance" "mysql" {
  identifier = "${var.project_prefix}-rds-mysql"

  # MySQL 8.0 engine
  engine         = "mysql"
  engine_version = "8.0.40"
  instance_class = var.db_instance_class

  # Storage configuration
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp2"
  storage_encrypted = false

  # Database credentials - from variables
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Public access enabled for demo only
  publicly_accessible = true

  # Single AZ for cost savings
  multi_az               = false
  availability_zone      = data.aws_availability_zones.available.names[0]

  # Backup configuration
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  copy_tags_to_snapshot   = true

  # Maintenance configuration
  maintenance_window      = "sun:04:00-sun:05:00"
  auto_minor_version_upgrade = true

  # Skip final snapshot for easy cleanup
  skip_final_snapshot = true
  deletion_protection = false

  # Performance and monitoring
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  performance_insights_enabled    = false

  tags = {
    Name = "${var.project_prefix}-rds-mysql"
  }
}
