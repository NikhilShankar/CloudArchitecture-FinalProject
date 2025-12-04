# CloudFormation Architecture Overview

## Project: AWS Infrastructure Deployment using CloudFormation

**Prefix Convention:** `cloudinfra-finalproject-cf-9026254-`

---

## Architecture Components

### 1. Storage Layer - S3 Buckets
- **Component:** 3 Private S3 Buckets
- **Purpose:** Secure object storage with versioning enabled
- **Security:**
  - Public access completely blocked via `PublicAccessBlockConfiguration`
  - No public read/write permissions
  - Versioning enabled for data protection and recovery
- **Naming:**
  - `cloudinfra-finalproject-cf-9026254-bucket-1`
  - `cloudinfra-finalproject-cf-9026254-bucket-2`
  - `cloudinfra-finalproject-cf-9026254-bucket-3`

---

### 2. Compute Layer - EC2 Instance

#### 2.1 Network Infrastructure (VPC)
- **VPC CIDR:** 10.0.0.0/16
- **Public Subnet:** 10.0.1.0/24 (for EC2 instance)
- **Internet Gateway:** Enables internet connectivity
- **Route Table:** Routes traffic from subnet to Internet Gateway
- **Security Group:** Allows SSH access (port 22) from anywhere

#### 2.2 EC2 Instance
- **Instance Type:** Parameterized (default: t2.micro)
- **AMI:** Parameterized (region-specific Amazon Linux 2)
- **Network:** Deployed in public subnet with auto-assigned public IP
- **Access:** SSH enabled via key pair
- **Naming:** `cloudinfra-finalproject-cf-9026254-ec2-instance`

---

### 3. Database Layer - RDS Instance

#### 3.1 Network Configuration
- **DB Subnet Group:** Spans multiple availability zones
- **Subnets:**
  - Private Subnet 1: 10.0.3.0/24 (AZ 1)
  - Private Subnet 2: 10.0.4.0/24 (AZ 2)
- **Security Group:** Allows MySQL traffic (port 3306)

#### 3.2 RDS MySQL Database
- **Engine:** MySQL 8.0
- **Instance Class:** db.t3.micro
- **Storage:** 20 GB General Purpose SSD (gp2)
- **Configuration:**
  - Database name, username, password: Parameterized
  - Public accessibility: Enabled (for project demonstration only)
  - Backup retention: 7 days
  - Multi-AZ: Disabled (cost optimization)
- **Naming:** `cloudinfra-finalproject-cf-9026254-rds-mysql`

---

## Architecture Diagram (Conceptual)

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                            │
│                                                               │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  VPC (10.0.0.0/16)                                     │ │
│  │                                                         │ │
│  │  ┌──────────────────────┐  ┌──────────────────────┐  │ │
│  │  │  Public Subnet       │  │  Private Subnets     │  │ │
│  │  │  (10.0.1.0/24)       │  │  (10.0.3.0/24)       │  │ │
│  │  │                      │  │  (10.0.4.0/24)       │  │ │
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
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐           │ │
│  │  │ Bucket 1 │  │ Bucket 2 │  │ Bucket 3 │           │ │
│  │  │ (Private)│  │ (Private)│  │ (Private)│           │ │
│  │  └──────────┘  └──────────┘  └──────────┘           │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Security Features

1. **S3 Buckets:**
   - Block all public access
   - Versioning enabled for data protection

2. **EC2 Instance:**
   - Security group restricts access to SSH only (port 22)
   - Deployed in public subnet for accessibility
   - Key pair authentication required

3. **RDS Database:**
   - Deployed in private subnets
   - Security group allows only MySQL traffic (port 3306)
   - Encrypted credentials via CloudFormation parameters

---

## CloudFormation Stacks

The infrastructure is divided into separate stacks for modularity:

1. **S3 Stack:** `cloudinfra-finalproject-cf-9026254-s3-stack`
2. **Network Stack:** `cloudinfra-finalproject-cf-9026254-network-stack`
3. **EC2 Stack:** `cloudinfra-finalproject-cf-9026254-ec2-stack`
4. **RDS Stack:** `cloudinfra-finalproject-cf-9026254-rds-stack`

---

## Infrastructure as Code Benefits

- **Reproducibility:** Entire infrastructure can be recreated with single command
- **Version Control:** Templates tracked in Git
- **Documentation:** Templates serve as infrastructure documentation
- **Consistency:** Same configuration deployed every time
- **Modularity:** Separate stacks for different components
