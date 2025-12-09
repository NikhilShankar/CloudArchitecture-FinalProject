# AWS Infrastructure Automation - Presentation Content
**Course:** PROG 8870 - Cloud Architecture
**Student ID:** 9026254
**Duration:** 5-10 minutes

---

## Slide 1: Title Slide
**Title:** AWS Infrastructure Automation with Terraform & CloudFormation
**Subtitle:** Deploying Multi-Service Cloud Environments Using IaC
**Student ID:** 9026254

---

## Slide 2: Project Overview
**What We Built:**
- Two identical AWS infrastructures using different IaC tools
- CloudFormation deployment (AWS-native)
- Terraform deployment (multi-cloud tool)
- Both fully functional and independent

**Key Numbers:**
- 2 deployment methods
- 7+ AWS services utilized
- 4 separate resource stacks
- 100% infrastructure as code

---

## Slide 3: AWS Infrastructure Components

**Resources Deployed (Each Tool):**

**Storage Layer:**
- S3 buckets (CF: 3, Terraform: 4)
- Versioning enabled
- Public access blocked

**Network Layer:**
- VPC with custom CIDR (CF: 10.0.0.0/16, Terraform: 10.1.0.0/16)
- 3 Subnets (1 public, 2 private)
- Internet Gateway
- Route tables and associations

**Compute Layer:**
- EC2 instance (t2.micro)
- Public IP assignment
- SSH access via key pair

**Database Layer:**
- RDS MySQL database (db.t3.micro)
- Multi-AZ subnet group
- Secure private subnet placement

---

## Slide 4: Code Structure - CloudFormation

**Architecture Approach:**
```
cloudformation/
├── parameters.yaml      # Single source of truth
├── s3-buckets.yaml     # Storage resources
├── network.yaml        # VPC infrastructure
├── ec2-instance.yaml   # Compute resources
└── rds-instance.yaml   # Database resources
```

**Key Design Decisions:**
- Modular stack separation (5 independent stacks)
- Cross-stack references via Exports/Imports
- Parameters stack for global configuration
- Template reusability

**CloudFormation Best Practices:**
- ✅ Stack exports for inter-stack dependencies
- ✅ Parameter-driven configuration
- ✅ Descriptive resource naming
- ✅ Proper dependency management

---

## Slide 5: Code Structure - Terraform

**Architecture Approach:**
```
terraform/
├── provider.tf         # AWS provider config
├── variables.tf        # Variable definitions
├── terraform.tfvars    # Variable values (not in Git)
├── backend.tf          # State management
├── s3.tf              # Storage resources
├── vpc.tf             # Network infrastructure
├── ec2.tf             # Compute resources
├── rds.tf             # Database resources
└── outputs.tf         # Output definitions
```

**Key Design Decisions:**
- Resource separation by service type
- Dynamic AMI fetching (latest Amazon Linux 2)
- Centralized variable management
- Comprehensive output values

**Terraform Best Practices:**
- ✅ Variables with sensible defaults
- ✅ Sensitive data handling (passwords)
- ✅ Resource naming with prefix
- ✅ Output values for verification
- ✅ .tfvars excluded from Git

---

## Slide 6: Modularity & Best Practices

**CloudFormation Modularity:**
- **Stack Separation:** Each service in separate stack
- **Parameters Stack:** Global configuration exported
- **Import Pattern:** `!ImportValue GlobalProjectPrefix`
- **Benefits:** Update one stack without affecting others

**Terraform Modularity:**
- **File Separation:** Each service in separate .tf file
- **Variable System:** Centralized in variables.tf
- **Reusability:** Change prefix once, affects all resources
- **Benefits:** Easy to extend, clear organization

**Shared Best Practices:**
- Consistent naming conventions
- No hardcoded values
- Security-first approach (private subnets for RDS)
- Resource tagging for management
- Documentation alongside code

---

## Slide 7: Key Features Implemented

**Dynamic Configuration:**
- Terraform: Dynamic AMI lookup (always latest Amazon Linux 2)
- CloudFormation: Parameter-based customization
- Both: Configurable instance types

**Security Features:**
- S3: Versioning enabled, public access blocked
- RDS: Private subnet deployment only
- EC2: Security groups with minimal required access
- Passwords: Marked as sensitive/NoEcho

**Infrastructure Independence:**
- Separate VPC CIDRs (avoid conflicts)
- Unique resource prefixes
- Can run both simultaneously

**State Management:**
- CloudFormation: AWS-managed (automatic)
- Terraform: Local state file (terraform.tfstate)

---

## Slide 8: Challenges Encountered

**Challenge 1: Key Pair Management**
- **Issue:** Key pair must exist before deployment
- **Solution:** Pre-create in AWS, reference by name
- **Learning:** AWS resources vs. Terraform managed resources

**Challenge 2: RDS Subnet Requirements**
- **Issue:** RDS needs subnet group with 2+ AZs
- **Solution:** Created 2 private subnets in different AZs
- **Learning:** AWS service-specific requirements

**Challenge 3: CloudFormation Stack Dependencies**
- **Issue:** Stacks must be created in correct order
- **Solution:** Export/Import pattern with parameters stack first
- **Learning:** Dependency management in CloudFormation

**Challenge 4: Variable Handling**
- **Issue:** Sensitive data (passwords) in terraform.tfvars
- **Solution:** Mark as sensitive, exclude from Git
- **Learning:** Security best practices for IaC

**Challenge 5: Deployment Time**
- **Issue:** RDS takes 10-15 minutes to create
- **Solution:** Patience, parallel resource creation where possible
- **Learning:** AWS resource creation is asynchronous

---

## Slide 9: Comparison - CloudFormation vs Terraform

| **Aspect** | **CloudFormation** | **Terraform** |
|------------|-------------------|---------------|
| **Language** | YAML | HCL |
| **State Management** | AWS-managed | Local/Remote files |
| **Multi-Cloud** | AWS only | Multi-cloud support |
| **Stack Management** | Separate stacks | Single state |
| **Modularity** | Stack exports/imports | File separation |
| **Learning Curve** | AWS-specific | Broader applicability |
| **Deployment** | Sequential stacks | Single apply |

**When to Use What:**
- **CloudFormation:** AWS-only projects, tight AWS integration
- **Terraform:** Multi-cloud, existing Terraform expertise

---

## Slide 10: Deployment Process

**CloudFormation (5 Steps):**
1. Deploy parameters stack
2. Deploy S3 stack
3. Deploy network stack
4. Deploy EC2 stack
5. Deploy RDS stack

**Terraform (4 Steps):**
1. `terraform init` - Initialize
2. `terraform validate` - Validate syntax
3. `terraform plan` - Preview changes
4. `terraform apply` - Deploy

**Time to Deploy:**
- Both take ~15-20 minutes
- RDS is the slowest component

---


Google Slides Link : https://docs.google.com/presentation/d/1bJbugEcqJsz-7fnIWOmzGzaSeTyZ9QT8zhvbyoGAjGc/edit?usp=sharing