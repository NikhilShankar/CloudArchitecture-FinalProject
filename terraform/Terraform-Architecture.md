# Terraform Architecture Overview

## Project: AWS Infrastructure Deployment using Terraform

**Prefix Convention:** `cloudinfra-finalproject-terra-9026254-`

---

## Architecture Components

### 1. Storage Layer - S3 Buckets
- **Component:** 4 Private S3 Buckets
- **Purpose:** Secure object storage with versioning enabled
- **Security:**
  - Public access blocked via ACL and bucket policies
  - No public read/write permissions
  - Versioning enabled for data protection and recovery
- **Naming:**
  - `cloudinfra-finalproject-terra-9026254-bucket-1`
  - `cloudinfra-finalproject-terra-9026254-bucket-2`
  - `cloudinfra-finalproject-terra-9026254-bucket-3`
  - `cloudinfra-finalproject-terra-9026254-bucket-4`

---

### 2. Compute Layer - EC2 Instance

#### 2.1 Network Infrastructure (VPC)
- **VPC CIDR:** 10.1.0.0/16
- **Public Subnet:** 10.1.1.0/24 (for EC2 instance)
- **Private Subnet 1:** 10.1.3.0/24 (for RDS)
- **Private Subnet 2:** 10.1.4.0/24 (for RDS)
- **Internet Gateway:** Enables internet connectivity
- **Route Table:** Routes traffic from public subnet to Internet Gateway
- **Security Group:** Allows SSH access (port 22) from anywhere

#### 2.2 EC2 Instance
- **Instance Type:** Dynamic variable (default: t2.micro)
- **AMI:** Dynamic variable (automatically fetched latest Amazon Linux 2)
- **Network:** Deployed in public subnet with auto-assigned public IP
- **Access:** SSH enabled via key pair
- **Naming:** `cloudinfra-finalproject-terra-9026254-ec2-instance`

---

### 3. Database Layer - RDS Instance

#### 3.1 Network Configuration
- **DB Subnet Group:** Spans multiple availability zones
- **Subnets:**
  - Private Subnet 1: 10.1.3.0/24 (AZ 1)
  - Private Subnet 2: 10.1.4.0/24 (AZ 2)
- **Security Group:** Allows MySQL traffic (port 3306)

#### 3.2 RDS MySQL Database
- **Engine:** MySQL 8.0
- **Instance Class:** db.t3.micro
- **Storage:** 20 GB General Purpose SSD (gp2)
- **Configuration:**
  - Database name: Defined via input variable
  - Username: Defined via input variable
  - Password: Defined via input variable
  - Public accessibility: Enabled (for project demonstration only)
  - Backup retention: 7 days
  - Multi-AZ: Disabled (cost optimization)
- **Naming:** `cloudinfra-finalproject-terra-9026254-rds-mysql`

---

## Architecture Diagram (Conceptual)

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                            │
│                                                               │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  VPC (10.1.0.0/16)                                     │ │
│  │                                                         │ │
│  │  ┌──────────────────────┐  ┌──────────────────────┐  │ │
│  │  │  Public Subnet       │  │  Private Subnets     │  │ │
│  │  │  (10.1.1.0/24)       │  │  (10.1.3.0/24)       │  │ │
│  │  │                      │  │  (10.1.4.0/24)       │  │ │
│  │  │  ┌────────────┐      │  │                      │  │ │
│  │  │  │ EC2        │      │  │  ┌────────────┐     │  │ │
│  │  │  │ Instance   │      │  │  │    RDS     │     │  │ │
│  │  │  │            │      │  │  │   MySQL    │     │  │ │
│  │  │  └────────────┘      │  │  │            │     │  │ │
│  │  │       │              │  │  └────────────┘     │  │ │
│  │  └───────┼──────────────┘  └──────────────────────┘  │ │
│  │          │                                            │ │
│  │    ┌─────▼─────┐                                     │ │
│  │    │  Internet │                                     │ │
│  │    │  Gateway  │                                     │ │
│  │    └───────────┘                                     │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                               │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  S3 Buckets (Outside VPC)                             │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────┐ │ │
│  │  │ Bucket 1 │  │ Bucket 2 │  │ Bucket 3 │  │Bucket│ │ │
│  │  │ (Private)│  │ (Private)│  │ (Private)│  │  4   │ │ │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────┘ │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Security Features

1. **S3 Buckets:**
   - Block all public access
   - Versioning enabled for data protection
   - Private ACL enforced

2. **EC2 Instance:**
   - Security group restricts access to SSH only (port 22)
   - Deployed in public subnet for accessibility
   - Key pair authentication required

3. **RDS Database:**
   - Deployed in private subnets
   - Security group allows only MySQL traffic (port 3306)
   - Credentials managed via Terraform variables

---

## Terraform Configuration Structure

The infrastructure is organized into modular Terraform files:

1. **provider.tf** - AWS provider configuration
2. **variables.tf** - All variable definitions
3. **terraform.tfvars** - Variable values (not committed to Git)
4. **backend.tf** - State file configuration (local backend)
5. **s3.tf** - S3 bucket resources (4 buckets)
6. **vpc.tf** - VPC, subnets, IGW, route tables, security groups
7. **ec2.tf** - EC2 instance configuration
8. **rds.tf** - RDS database configuration
9. **outputs.tf** - Output values for resources

---

## Dynamic Configuration

All critical values are parameterized through variables:

- **Project Prefix:** Single variable controls all resource naming
- **AMI ID:** Automatically fetched latest Amazon Linux 2 AMI
- **Instance Type:** Configurable (default: t2.micro)
- **VPC/Subnet CIDRs:** Configurable network ranges
- **RDS Credentials:** Database name, username, password via variables
- **Key Pair Name:** SSH key for EC2 access

---

## Infrastructure as Code Benefits

- **Reproducibility:** Entire infrastructure recreated with `terraform apply`
- **Version Control:** All configuration tracked in Git
- **Documentation:** Code serves as infrastructure documentation
- **Consistency:** Same configuration deployed every time
- **Modularity:** Separate files for different resource types
- **Variables:** Easy to customize without changing code

---

## Differences from CloudFormation Implementation

1. **VPC CIDR:** 10.1.0.0/16 (vs 10.0.0.0/16 in CloudFormation)
2. **S3 Buckets:** 4 buckets (vs 3 in CloudFormation)
3. **Syntax:** HCL (HashiCorp Configuration Language) vs YAML
4. **State Management:** Local state file vs CloudFormation service-managed
5. **Naming Prefix:** `-terra-` vs `-cf-` for easy identification
