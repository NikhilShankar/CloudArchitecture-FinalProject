# AWS Infrastructure Automation - Final Project

**Course:** PROG 8870 - Cloud Architecture
**Student ID:** 9026254
**Project:** Deploying AWS Infrastructure with Terraform and CloudFormation

---

## Project Overview

This project demonstrates Infrastructure as Code (IaC) using both **AWS CloudFormation** and **Terraform** to deploy identical multi-service AWS environments. Each tool creates separate infrastructure with S3 buckets, VPC networking, EC2 instances, and RDS databases.

---

## Infrastructure Components

### CloudFormation Deployment
- **Prefix:** `cloudinfra-finalproject-cf-9026254-`
- **VPC CIDR:** 10.0.0.0/16
- **Resources:** 3 S3 buckets, VPC with networking, 1 EC2 instance, 1 RDS MySQL database

### Terraform Deployment
- **Prefix:** `cloudinfra-finalproject-terra-9026254-`
- **VPC CIDR:** 10.1.0.0/16
- **Resources:** 4 S3 buckets, VPC with networking, 1 EC2 instance, 1 RDS MySQL database

Both deployments are completely independent and can coexist in the same AWS account.

---

## Quick Start

### CloudFormation
```bash
# Deploy parameters stack first
aws cloudformation create-stack \
  --stack-name cloudinfra-finalproject-cf-9026254-params-stack \
  --template-body file://cloudformation/parameters.yaml \
  --region us-east-1

# Then deploy other stacks (S3, Network, EC2, RDS)
```

📖 **Full Guide:** [cloudformation/CloudFormation-Implementation.md](cloudformation/CloudFormation-Implementation.md)

### Terraform
```bash
cd terraform

# Initialize and deploy
terraform init
terraform plan
terraform apply
```

📖 **Full Guide:** [terraform/Terraform-Implementation.md](terraform/Terraform-Implementation.md)

---

## Project Structure

```
FinalProject/
├── README.md                      # This file
├── .gitignore                     # Protects sensitive data
│
├── cloudformation/                # AWS CloudFormation templates
│   ├── CloudFormation-Architecture.md
│   ├── CloudFormation-Implementation.md
│   ├── parameters.yaml            # Global configuration
│   ├── s3-buckets.yaml           # 3 S3 buckets
│   ├── network.yaml              # VPC and networking
│   ├── ec2-instance.yaml         # EC2 instance
│   └── rds-instance.yaml         # MySQL RDS database
│
├── terraform/                     # Terraform configuration
│   ├── Terraform-Architecture.md
│   ├── Terraform-Implementation.md
│   ├── provider.tf               # AWS provider
│   ├── variables.tf              # Variable definitions
│   ├── terraform.tfvars          # Variable values (not in Git)
│   ├── backend.tf                # State management
│   ├── s3.tf                     # 4 S3 buckets
│   ├── vpc.tf                    # VPC and networking
│   ├── ec2.tf                    # EC2 instance
│   ├── rds.tf                    # MySQL RDS database
│   └── outputs.tf                # Resource outputs
│
├── screenshots/                   # AWS Console screenshots
└── presentation/                  # Demo presentation slides
```

---

## Prerequisites

- AWS CLI installed and configured
- Terraform installed (version 1.0+)
- AWS Account with appropriate permissions
- Valid EC2 Key Pair for SSH access

---

## Documentation

### CloudFormation
- **Architecture:** [cloudformation/CloudFormation-Architecture.md](cloudformation/CloudFormation-Architecture.md)
- **Implementation Guide:** [cloudformation/CloudFormation-Implementation.md](cloudformation/CloudFormation-Implementation.md)

### Terraform
- **Architecture:** [terraform/Terraform-Architecture.md](terraform/Terraform-Architecture.md)
- **Implementation Guide:** [terraform/Terraform-Implementation.md](terraform/Terraform-Implementation.md)

---

## Key Features

### CloudFormation
✅ Single source of truth via parameters stack
✅ Stack exports/imports for dependencies
✅ YAML-based configuration
✅ AWS-native service-managed state

### Terraform
✅ Dynamic AMI fetching (latest Amazon Linux 2)
✅ Dynamic instance type configuration
✅ HCL-based configuration
✅ Local state management
✅ Comprehensive outputs

---

## Configuration

### CloudFormation
Edit `cloudformation/parameters.yaml` to change the project prefix:
```yaml
Parameters:
  ProjectPrefix:
    Default: 'cloudinfra-finalproject-cf-9026254'
```

### Terraform
Edit `terraform/terraform.tfvars` with your values:
```hcl
project_prefix = "cloudinfra-finalproject-terra-9026254"
key_pair_name  = "your-key-pair-name"
db_password    = "YourSecurePassword123!"
```

**IMPORTANT:** `terraform.tfvars` is not committed to Git (contains sensitive data).

---

## Cleanup

### CloudFormation
Delete stacks in reverse order:
```bash
aws cloudformation delete-stack --stack-name cloudinfra-finalproject-cf-9026254-rds-stack
aws cloudformation delete-stack --stack-name cloudinfra-finalproject-cf-9026254-ec2-stack
aws cloudformation delete-stack --stack-name cloudinfra-finalproject-cf-9026254-network-stack
aws cloudformation delete-stack --stack-name cloudinfra-finalproject-cf-9026254-s3-stack
aws cloudformation delete-stack --stack-name cloudinfra-finalproject-cf-9026254-params-stack
```

### Terraform
```bash
cd terraform
terraform destroy
```

---


