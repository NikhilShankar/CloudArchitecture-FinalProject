# Terraform configuration block
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS provider configuration
provider "aws" {
  region = var.aws_region

  # Default tags applied to all resources
  default_tags {
    tags = {
      Project     = "Terraform-Final-Project"
      ManagedBy   = "Terraform"
      Environment = "Development"
      StudentID   = "9026254"
    }
  }
}
