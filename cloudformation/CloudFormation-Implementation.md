# CloudFormation Implementation Guide

## Project: AWS Infrastructure Deployment using CloudFormation
**Student ID:** 9026254
**Prefix:** `cloudinfra-finalproject-cf-9026254-`

---

## Prerequisites

- AWS CLI installed and configured
- AWS Account with appropriate permissions
- Valid AWS Key Pair for EC2 access

---

## Deployment Steps

**IMPORTANT:** Deploy stacks in this exact order. The parameters stack must be deployed first as it exports the project prefix used by all other stacks.

### 0. Global Parameters Stack (Deploy First!)

#### Template: `parameters.yaml`

**Stack Name:** `cloudinfra-finalproject-cf-9026254-params-stack`

**Deployment Command:**
```bash
aws cloudformation create-stack \
  --stack-name cloudinfra-finalproject-cf-9026254-params-stack \
  --template-body file://cloudformation/parameters.yaml \
  --region us-east-1
```

**What This Does:**
- Creates global project prefix export
- Single source of truth for naming convention
- Change prefix in one place, applies to all stacks

**To change the project prefix:**
Edit `parameters.yaml` and modify the `ProjectPrefix` default value. All other stacks will automatically use the new prefix.

**[SCREENSHOT PLACEHOLDER: CloudFormation Parameters Stack - CREATE_COMPLETE Status]**

---

### 1. S3 Buckets Deployment

#### Template: `s3-buckets.yaml`

**Stack Name:** `cloudinfra-finalproject-cf-9026254-s3-stack`

**Deployment Command:**
```bash
aws cloudformation create-stack --stack-name cloudinfra-finalproject-cf-9026254-s3-stack --template-body file://cloudformation/s3-buckets.yaml --region us-east-1
```

**Verification Steps:**
1. Check stack status in CloudFormation console
2. Verify 3 S3 buckets are created
3. Confirm versioning is enabled on all buckets
4. Verify public access is blocked

**[SCREENSHOT PLACEHOLDER: CloudFormation S3 Stack - CREATE_COMPLETE Status]**

**[SCREENSHOT PLACEHOLDER: S3 Console showing 3 buckets with naming convention]**

**[SCREENSHOT PLACEHOLDER: S3 Bucket Properties showing Versioning Enabled]**

**[SCREENSHOT PLACEHOLDER: S3 Bucket Permissions showing Block Public Access enabled]**

---

### 2. Network Infrastructure (VPC) Deployment

#### Template: `network.yaml`

**Stack Name:** `cloudinfra-finalproject-cf-9026254-network-stack`

**Deployment Command:**
```bash
aws cloudformation create-stack \
  --stack-name cloudinfra-finalproject-cf-9026254-network-stack \
  --template-body file://cloudformation/network.yaml \
  --region us-east-1
```

**What This Creates:**
- VPC (10.0.0.0/16)
- Public Subnet (10.0.1.0/24)
- Private Subnet 1 (10.0.3.0/24)
- Private Subnet 2 (10.0.4.0/24)
- Internet Gateway
- Route Tables
- Security Groups for EC2 and RDS

**[SCREENSHOT PLACEHOLDER: CloudFormation Network Stack - CREATE_COMPLETE Status]**

**[SCREENSHOT PLACEHOLDER: VPC Console showing created VPC with correct CIDR]**

**[SCREENSHOT PLACEHOLDER: Subnets Console showing all 3 subnets]**

**[SCREENSHOT PLACEHOLDER: Internet Gateway attached to VPC]**

---

### 3. EC2 Instance Deployment

#### Create PEM Keys for SSH 
```
aws ec2 create-key-pair  --key-name cloudinfra-finalproject-keypair  --query 'KeyMaterial'  --output text  --region us-east-1 > cloudinfra-finalproject-keypair.pem  
```

#### Template: `ec2-instance.yaml`

**Stack Name:** `cloudinfra-finalproject-cf-9026254-ec2-stack`

**Deployment Command:**
```bash
aws cloudformation create-stack \
  --stack-name cloudinfra-finalproject-cf-9026254-ec2-stack \
  --template-body file://cloudformation/ec2-instance.yaml \
  --parameters \
    ParameterKey=KeyPairName,ParameterValue=<your-key-pair-name> \
    ParameterKey=InstanceType,ParameterValue=t2.micro \
  --region us-east-1
```



**Parameters Used:**
- `KeyPairName`: Your existing EC2 key pair
- `InstanceType`: t2.micro (free tier eligible)
- `LatestAmiId`: Amazon Linux 2 AMI (automatically fetched)

**Stack Outputs:**
- EC2 Instance ID
- Public IP Address
- Public DNS Name

**[SCREENSHOT PLACEHOLDER: CloudFormation EC2 Stack - CREATE_COMPLETE Status]**

**[SCREENSHOT PLACEHOLDER: EC2 Console showing running instance with public IP]**

**[SCREENSHOT PLACEHOLDER: CloudFormation Stack Outputs showing Public IP]**

**[SCREENSHOT PLACEHOLDER: Security Group showing SSH (port 22) inbound rule]**

---

### 4. RDS MySQL Database Deployment

#### Template: `rds-instance.yaml`

**Stack Name:** `cloudinfra-finalproject-cf-9026254-rds-stack`

**Deployment Command:**
```bash
aws cloudformation create-stack \
  --stack-name cloudinfra-finalproject-cf-9026254-rds-stack \
  --template-body file://cloudformation/rds-instance.yaml \
  --parameters \
    ParameterKey=DBName,ParameterValue=myappdatabase \
    ParameterKey=DBUsername,ParameterValue=admin \
    ParameterKey=DBPassword,ParameterValue=<secure-password> \
  --region us-east-1
```

**Parameters Used:**
- `DBName`: Database name (e.g., myappdatabase)
- `DBUsername`: Master username (e.g., admin)
- `DBPassword`: Master password (minimum 8 characters)

**Stack Outputs:**
- RDS Endpoint
- RDS Port (3306)
- Database Name

**[SCREENSHOT PLACEHOLDER: CloudFormation RDS Stack - CREATE_COMPLETE Status]**

**[SCREENSHOT PLACEHOLDER: RDS Console showing running MySQL database]**

**[SCREENSHOT PLACEHOLDER: RDS Instance details showing endpoint and availability]**

**[SCREENSHOT PLACEHOLDER: CloudFormation Stack Outputs showing RDS endpoint]**

---

## Verification Checklist

### S3 Buckets
- [ ] 3 buckets created with correct naming convention
- [ ] Versioning enabled on all buckets
- [ ] Public access blocked on all buckets
- [ ] Buckets visible in S3 console

### Network Infrastructure
- [ ] VPC created with correct CIDR (10.0.0.0/16)
- [ ] 3 subnets created (1 public, 2 private)
- [ ] Internet Gateway attached to VPC
- [ ] Route table configured for public subnet
- [ ] Security groups created for EC2 and RDS

### EC2 Instance
- [ ] EC2 instance running
- [ ] Public IP address assigned
- [ ] SSH access working (port 22)
- [ ] Instance located in public subnet
- [ ] Stack outputs display public IP

### RDS Database
- [ ] RDS instance available
- [ ] MySQL engine version 8.0
- [ ] Instance class db.t3.micro
- [ ] Endpoint accessible
- [ ] Security group allows MySQL traffic (port 3306)

---

## CloudFormation Stack Management

### List All Stacks
```bash
aws cloudformation list-stacks --region us-east-1
```

### Check Stack Status
```bash
aws cloudformation describe-stacks \
  --stack-name cloudinfra-finalproject-cf-9026254-s3-stack \
  --region us-east-1
```

### View Stack Outputs
```bash
aws cloudformation describe-stacks \
  --stack-name cloudinfra-finalproject-cf-9026254-ec2-stack \
  --query 'Stacks[0].Outputs' \
  --region us-east-1
```

### Delete Stack (Cleanup)
```bash
aws cloudformation delete-stack \
  --stack-name cloudinfra-finalproject-cf-9026254-s3-stack \
  --region us-east-1
```

**Note:** Delete stacks in reverse order to avoid dependency issues:
1. RDS Stack
2. EC2 Stack
3. Network Stack
4. S3 Stack
5. Parameters Stack (delete last - all other stacks depend on it)

---

## Common Issues and Troubleshooting

### Issue: Stack creation fails with "CREATE_FAILED"
**Solution:** Check CloudFormation Events tab for error details

### Issue: Key pair not found
**Solution:** Create key pair in EC2 console first or use existing one

### Issue: RDS creation takes too long
**Solution:** RDS typically takes 10-15 minutes to create, be patient

### Issue: Cannot SSH into EC2 instance
**Solution:** Verify security group allows SSH from your IP address

---

## Cost Considerations

**Estimated Monthly Costs (AWS Free Tier):**
- S3 Buckets: Free (under 5GB storage)
- EC2 t2.micro: Free (750 hours/month)
- RDS db.t3.micro: Free (750 hours/month)

**Important:** Remember to delete resources after demonstration to avoid charges.

---

## Screenshots Summary

Total screenshots required: **17**

1. Parameters Stack - CREATE_COMPLETE
2. S3 Stack - CREATE_COMPLETE
3. S3 Console - 3 Buckets List
4. S3 Versioning Enabled
5. S3 Block Public Access
6. Network Stack - CREATE_COMPLETE
7. VPC Console
8. Subnets Console
9. Internet Gateway
10. EC2 Stack - CREATE_COMPLETE
11. EC2 Instance Running
12. EC2 Public IP Output
13. Security Group Rules
14. RDS Stack - CREATE_COMPLETE
15. RDS Instance Available
16. RDS Instance Details
17. RDS Endpoint Output

---

## Next Steps

After completing CloudFormation deployment:
1. Take all required screenshots
2. Save screenshots in `/screenshots` folder with descriptive names
3. Commit CloudFormation templates and documentation to GitHub
4. Proceed with Terraform implementation (separate infrastructure)
