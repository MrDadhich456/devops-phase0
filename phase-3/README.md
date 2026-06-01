# Phase 3 — AWS Fundamentals

> Learning AWS the right way — CLI only. No console clicking.
> Every resource provisioned and terminated via `aws cli`.

---

## What I Built

- Configured IAM user with MFA, created access keys, set up AWS CLI
- Launched EC2 t2.micro via CLI, created key pair, set up security groups, SSH'd in
- Installed Docker on EC2 and ran my containerised app from Docker Hub remotely
- Created S3 bucket, uploaded/downloaded files, synced entire folders
- Built a custom VPC with public + private subnets, internet gateway, and route tables
- Set up a CloudWatch billing alarm to alert at $1 spend

---

## Key Commands Used

### IAM & CLI Setup
```bash
# Configure CLI with IAM user credentials
aws configure
# Verify identity
aws sts get-caller-identity
```

### EC2 — Launch & Connect
```bash
# Create key pair and save locally
aws ec2 create-key-pair \
  --key-name devops-key \
  --query 'KeyMaterial' \
  --output text > devops-key.pem

# Lock down key permissions (SSH refuses open keys)
chmod 400 devops-key.pem

# Create security group
aws ec2 create-security-group \
  --group-name devops-sg \
  --description "DevOps learning SG"

# Allow SSH (port 22)
aws ec2 authorize-security-group-ingress \
  --group-id <sg-id> \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0

# Allow HTTP (port 80)
aws ec2 authorize-security-group-ingress \
  --group-id <sg-id> \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

# Launch EC2 instance
aws ec2 run-instances \
  --image-id <ami-id> \
  --instance-type t2.micro \
  --key-name devops-key \
  --security-group-ids <sg-id> \
  --count 1

# Get public IP
aws ec2 describe-instances \
  --instance-ids <instance-id> \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text

# SSH into instance
ssh -i devops-key.pem ec2-user@<public-ip>

# Install Docker on EC2
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

# Pull and run Docker image from Docker Hub
docker pull mrdadhich456/calculator:latest
docker run mrdadhich456/calculator:latest
```

### S3 — Storage
```bash
# Create bucket (must be globally unique)
aws s3api create-bucket \
  --bucket devops-aaryan-2026 \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

# Upload a file
aws s3 cp posts.json s3://devops-aaryan-2026/data/posts.json

# List bucket contents
aws s3 ls s3://devops-aaryan-2026/

# Download file back
aws s3 cp s3://devops-aaryan-2026/data/posts.json ./downloaded.json

# Sync entire folder
aws s3 sync ./python/ s3://devops-aaryan-2026/code/

# Clean up — empty then delete
aws s3 rm s3://devops-aaryan-2026 --recursive
aws s3api delete-bucket --bucket devops-aaryan-2026
```

### VPC — Custom Networking
```bash
# Create custom VPC (65,536 IPs)
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create public subnet (256 IPs)
aws ec2 create-subnet \
  --vpc-id <vpc-id> \
  --cidr-block 10.0.1.0/24

# Create private subnet
aws ec2 create-subnet \
  --vpc-id <vpc-id> \
  --cidr-block 10.0.2.0/24

# Create and attach Internet Gateway (gives public subnet internet access)
aws ec2 create-internet-gateway
aws ec2 attach-internet-gateway \
  --vpc-id <vpc-id> \
  --internet-gateway-id <igw-id>

# Add route to internet in public subnet route table
aws ec2 create-route \
  --route-table-id <rtb-id> \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id <igw-id>
```

### Billing Alarm
```bash
# Set CloudWatch alarm if estimated charges exceed $1
aws cloudwatch put-metric-alarm \
  --alarm-name "BillingAlert-1USD" \
  --metric-name EstimatedCharges \
  --namespace AWS/Billing \
  --statistic Maximum \
  --period 86400 \
  --threshold 1 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=Currency,Value=USD \
  --evaluation-periods 1 \
  --alarm-actions <sns-topic-arn>
```

### Cleanup — Always terminate when done
```bash
# Terminate EC2 instance
aws ec2 terminate-instances --instance-ids <instance-id>

# Delete security group
aws ec2 delete-security-group --group-id <sg-id>

# Delete key pair
aws ec2 delete-key-pair --key-name devops-key

# Delete VPC resources (order matters)
# subnets → detach + delete IGW → route tables → VPC
aws ec2 delete-subnet --subnet-id <subnet-id>
aws ec2 detach-internet-gateway --vpc-id <vpc-id> --internet-gateway-id <igw-id>
aws ec2 delete-internet-gateway --internet-gateway-id <igw-id>
aws ec2 delete-vpc --vpc-id <vpc-id>
```

---

## What I Learned

**IAM is AWS security rule #1.** Never use the root account for daily work. Every action should go through an IAM user with the least privilege needed. Creating a separate `devops-admin` user and enabling MFA on root was the first thing I did — and understanding why this matters changed how I think about cloud security.

**VPC networking clicked when I understood the public vs private subnet difference.** A public subnet has a route to an Internet Gateway — traffic can flow in and out. A private subnet has no such route — it's isolated. Databases go in private subnets. Web servers go in public subnets. That single concept explains how most production AWS architectures are structured.

**The CLI-first approach is the right way to learn.** Clicking around the console hides what's actually happening. Writing `aws ec2 run-instances` with all the flags forces you to understand every parameter — AMI ID, instance type, security group, key pair. When something fails, the error tells you exactly what's wrong. The console would have just shown a spinner.

**Always terminate everything.** t2.micro costs $0.0116/hour. Leaving it running for a week by mistake = a surprise bill. The discipline of running `terraform destroy` (which I'll learn in Phase 4) comes from this habit.

---

## Architecture Overview

```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
Public Subnet (10.0.1.0/24)
    │  EC2 t2.micro
    │  Docker container running
    │
Private Subnet (10.0.2.0/24)
    │  (no internet route — for DBs)
    │
VPC (10.0.0.0/16)
```

---

## Next → Phase 4: Terraform

Everything in this README — EC2, S3, VPC, security groups — will be recreated
in a single `terraform apply` command. Infrastructure as Code.