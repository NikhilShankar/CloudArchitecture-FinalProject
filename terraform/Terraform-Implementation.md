# Terraform Implementation Guide

## Project: AWS Infrastructure Deployment using Terraform
**Student ID:** 9026254
**Prefix:** `cloudinfra-finalproject-terra-9026254-`

---

## Prerequisites

- Terraform installed (version 1.0+)
- AWS CLI installed and configured
- AWS Account with appropriate permissions
- Valid AWS Key Pair for EC2 access

---

## Project Structure

```
terraform/
├── provider.tf         # AWS provider configuration
├── variables.tf        # Variable definitions
├── terraform.tfvars    # Variable values (sensitive - not in Git)
├── backend.tf          # State management configuration
├── s3.tf              # S3 bucket resources
├── vpc.tf             # VPC and networking resources
├── ec2.tf             # EC2 instance configuration
├── rds.tf             # RDS database configuration
└── outputs.tf         # Output definitions
```

---

## Configuration Steps

### Step 1: Configure Variables

Edit `terraform.tfvars` with your specific values:

```hcl
# Project configuration
project_prefix = "cloudinfra-finalproject-terra-9026254"
aws_region     = "us-east-1"

# EC2 configuration
instance_type = "t2.micro"
key_pair_name = "your-key-pair-name"

# RDS configuration
db_name     = "myappdatabase"
db_username = "admin"
db_password = "YourSecurePassword123!"  # Change this!
```

**IMPORTANT:** Never commit `terraform.tfvars` to Git as it contains sensitive data.

---

## Deployment Steps

### 1. Initialize Terraform

Navigate to terraform directory and initialize:

```bash
cd terraform
terraform init
```

**What This Does:**
- Downloads AWS provider plugins
- Initializes backend configuration
- Prepares working directory

**[SCREENSHOT PLACEHOLDER: Terraform init output showing successful initialization]**

---

### 2. Validate Configuration

Validate Terraform syntax:

```bash
terraform validate
```

**Expected Output:** "Success! The configuration is valid."

**[SCREENSHOT PLACEHOLDER: Terraform validate success message]**

---

### 3. Plan Infrastructure

Preview what Terraform will create:

```bash
terraform plan
```

**What to Look For:**
- 4 S3 buckets to be created
- VPC with 3 subnets
- EC2 instance
- RDS database
- Security groups and networking components

**[SCREENSHOT PLACEHOLDER: Terraform plan output showing resources to be created]**

---

### 4. Apply Configuration

Create the infrastructure:

```bash
terraform apply
```

Type `yes` when prompted to confirm.

**Deployment Time:**
- S3 Buckets: ~10 seconds
- VPC/Networking: ~30 seconds
- EC2 Instance: ~1-2 minutes
- RDS Database: ~10-15 minutes
- **Total: ~15-20 minutes**

**[SCREENSHOT PLACEHOLDER: Terraform apply in progress]**

**[SCREENSHOT PLACEHOLDER: Terraform apply complete with resource counts]**

---

### 5. Verify Resources

#### Check Terraform State

```bash
terraform show
```

#### List All Resources

```bash
terraform state list
```

**[SCREENSHOT PLACEHOLDER: Terraform state list showing all resources]**

---

## Resource Verification

### S3 Buckets Verification

#### AWS Console:
1. Navigate to S3 Console
2. Verify 4 buckets with correct naming
3. Check versioning is enabled
4. Confirm public access is blocked

#### CLI Command:
```bash
aws s3 ls | grep cloudinfra-finalproject-terra-9026254
```

**[SCREENSHOT PLACEHOLDER: S3 Console showing 4 buckets]**

**[SCREENSHOT PLACEHOLDER: S3 bucket properties showing versioning enabled]**

**[SCREENSHOT PLACEHOLDER: S3 bucket permissions showing block public access]**

---

### VPC and Networking Verification

#### AWS Console:
1. Navigate to VPC Console
2. Verify VPC with CIDR 10.1.0.0/16
3. Check 3 subnets (1 public, 2 private)
4. Confirm Internet Gateway attachment
5. Verify security groups

**[SCREENSHOT PLACEHOLDER: VPC Console showing VPC with correct CIDR]**

**[SCREENSHOT PLACEHOLDER: Subnets list showing all 3 subnets]**

**[SCREENSHOT PLACEHOLDER: Internet Gateway attached to VPC]**

**[SCREENSHOT PLACEHOLDER: Security groups for EC2 and RDS]**

---

### EC2 Instance Verification

#### Get Instance Details from Terraform:
```bash
terraform output ec2_public_ip
terraform output ec2_instance_id
```

#### AWS Console:
1. Navigate to EC2 Console
2. Verify instance is running
3. Check public IP is assigned
4. Confirm instance is in correct subnet

#### Test SSH Access:
```bash
ssh -i your-key-pair.pem ec2-user@<EC2_PUBLIC_IP>
```

**[SCREENSHOT PLACEHOLDER: EC2 Console showing running instance]**

**[SCREENSHOT PLACEHOLDER: EC2 instance details with public IP]**

**[SCREENSHOT PLACEHOLDER: Terraform outputs showing EC2 public IP]**

**[SCREENSHOT PLACEHOLDER: SSH connection successful]**

---

### RDS Database Verification

#### Get RDS Details from Terraform:
```bash
terraform output rds_endpoint
terraform output rds_port
```

#### AWS Console:
1. Navigate to RDS Console
2. Verify MySQL database is available
3. Check endpoint and port
4. Confirm instance class is db.t3.micro

#### Test MySQL Connection:
```bash
mysql -h <RDS_ENDPOINT> -P 3306 -u admin -p
```

**[SCREENSHOT PLACEHOLDER: RDS Console showing database available]**

**[SCREENSHOT PLACEHOLDER: RDS instance details]**

**[SCREENSHOT PLACEHOLDER: Terraform outputs showing RDS endpoint]**

**[SCREENSHOT PLACEHOLDER: MySQL connection successful]**

---

## Verification Checklist

### S3 Buckets
- [ ] 4 buckets created with correct naming convention
- [ ] Versioning enabled on all buckets
- [ ] Public access blocked on all buckets
- [ ] Buckets visible in S3 console

### Network Infrastructure
- [ ] VPC created with correct CIDR (10.1.0.0/16)
- [ ] 3 subnets created (1 public, 2 private)
- [ ] Internet Gateway attached to VPC
- [ ] Route table configured for public subnet
- [ ] Security groups created for EC2 and RDS

### EC2 Instance
- [ ] EC2 instance running
- [ ] Public IP address assigned
- [ ] SSH access working (port 22)
- [ ] Instance located in public subnet
- [ ] Terraform outputs display connection details

### RDS Database
- [ ] RDS instance available
- [ ] MySQL engine version 8.0
- [ ] Instance class db.t3.micro
- [ ] Endpoint accessible
- [ ] Security group allows MySQL traffic (port 3306)

---

## Terraform State Management

### View State

```bash
# Show current state
terraform show

# List all resources
terraform state list

# Show specific resource
terraform state show aws_instance.ec2_instance
```

### Backup State

```bash
# State file is stored locally at: terraform.tfstate
# Backup file is created automatically: terraform.tfstate.backup

# Create manual backup
cp terraform.tfstate terraform.tfstate.backup.$(date +%Y%m%d)
```

---

## Making Changes

### Update Variables

1. Edit `terraform.tfvars`
2. Run `terraform plan` to preview changes
3. Run `terraform apply` to apply changes

### Add New Resources

1. Edit appropriate `.tf` file
2. Run `terraform plan`
3. Run `terraform apply`

---

## Cleanup / Destruction

### Destroy All Resources

```bash
terraform destroy
```

Type `yes` when prompted.

**IMPORTANT:** This will delete ALL resources created by Terraform. Ensure you have backups of any important data.

**Destruction Order:**
Terraform automatically handles dependencies and destroys resources in the correct order.

**[SCREENSHOT PLACEHOLDER: Terraform destroy plan]**

**[SCREENSHOT PLACEHOLDER: Terraform destroy complete]**

---

## Common Commands Reference

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt

# Preview changes
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# List resources
terraform state list

# Get outputs
terraform output

# Destroy infrastructure
terraform destroy
```

---

## Common Issues and Troubleshooting

### Issue: "No valid credential sources found"
**Solution:** Configure AWS CLI with `aws configure`

### Issue: Key pair not found
**Solution:** Create key pair in EC2 console first, update `terraform.tfvars`

### Issue: RDS creation takes too long
**Solution:** RDS typically takes 10-15 minutes, be patient

### Issue: State file locked
**Solution:** Wait for other Terraform operations to complete, or remove lock file if stuck

### Issue: Resource already exists
**Solution:** Import existing resource or use different naming

---

## Screenshots Summary

Total screenshots required: **17**

1. Terraform init successful
2. Terraform validate success
3. Terraform plan output
4. Terraform apply in progress
5. Terraform apply complete
6. Terraform state list
7. S3 Console - 4 Buckets
8. S3 Versioning Enabled
9. S3 Block Public Access
10. VPC Console - VPC Details
11. Subnets Console - 3 Subnets
12. Internet Gateway
13. Security Groups
14. EC2 Instance Running
15. EC2 Instance Details
16. RDS Database Available
17. RDS Instance Details

---

## Cost Considerations

**Estimated Monthly Costs (AWS Free Tier):**
- S3 Buckets: Free (under 5GB storage)
- EC2 t2.micro: Free (750 hours/month)
- RDS db.t3.micro: Free (750 hours/month)
- VPC/Networking: Free

**Important:** Run `terraform destroy` after demonstration to avoid charges.

---

## Next Steps

After completing Terraform deployment:
1. Take all required screenshots
2. Save screenshots in `/screenshots` folder with descriptive names
3. Ensure `terraform.tfvars` is NOT committed to Git
4. Commit all `.tf` files and documentation to GitHub
5. Prepare demo presentation
