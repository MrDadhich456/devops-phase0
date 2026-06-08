# Phase 3 — AWS Fundamentals

> **Goal:** Deploy and manage cloud infrastructure using only the AWS CLI — zero console clicks.
> Duration: Week 4 · Days 20–26 · ~5 hrs/day

---

## Core Competencies

### Identity & Access Management (IAM)
Enforced least privilege — dedicated IAM admin user, never touched root account.

```bash
# Configure CLI
aws configure
aws sts get-caller-identity

# Create IAM user (via console first time, then CLI)
aws iam create-user --user-name devops-admin
aws iam attach-user-policy --user-name devops-admin \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

---

### Compute (EC2)
Provisioned and accessed instances entirely from terminal.

```bash
# Create key pair
aws ec2 create-key-pair \
  --key-name devops-key \
  --query 'KeyMaterial' \
  --output text > devops-key.pem
chmod 400 devops-key.pem

# Create security group
aws ec2 create-security-group \
  --group-name devops-sg \
  --description "DevOps SG"

# Allow SSH and HTTP
aws ec2 authorize-security-group-ingress \
  --group-id <sg-id> --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress \
  --group-id <sg-id> --protocol tcp --port 80 --cidr 0.0.0.0/0

# Launch instance
aws ec2 run-instances \
  --image-id <ami-id> \
  --instance-type t2.micro \
  --key-name devops-key \
  --security-group-ids <sg-id> \
  --count 1

# Get public IP
aws ec2 describe-instances \
  --instance-ids <id> \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text

# SSH in
ssh -i devops-key.pem ec2-user@<public-ip>

# Install Docker and run container
sudo yum install docker -y && sudo service docker start
sudo usermod -a -G docker ec2-user
docker pull mrdadhich456/calculator:latest
docker run mrdadhich456/calculator:latest
```

---

### Object Storage (S3)
Managed buckets and files entirely via CLI.

```bash
# Create bucket
aws s3api create-bucket \
  --bucket devops-aaryan-2026 \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

# Upload / download / sync
aws s3 cp posts.json s3://devops-aaryan-2026/data/posts.json
aws s3 cp s3://devops-aaryan-2026/data/posts.json ./downloaded.json
aws s3 sync ./python/ s3://devops-aaryan-2026/code/
aws s3 ls s3://devops-aaryan-2026/

# Cleanup
aws s3 rm s3://devops-aaryan-2026 --recursive
aws s3api delete-bucket --bucket devops-aaryan-2026
```

---

### Networking (VPC)
Engineered a custom VPC from scratch.

```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Public + private subnets
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.2.0/24

# Internet Gateway
aws ec2 create-internet-gateway
aws ec2 attach-internet-gateway \
  --vpc-id <vpc-id> --internet-gateway-id <igw-id>

# Route table
aws ec2 create-route \
  --route-table-id <rtb-id> \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id <igw-id>
```

---

### FinOps — Billing Alarm

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name "Billing-Alert-1USD" \
  --metric-name EstimatedCharges \
  --namespace AWS/Billing \
  --statistic Maximum \
  --threshold 1 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=Currency,Value=USD \
  --evaluation-periods 1 \
  --alarm-actions <sns-topic-arn>
```

---

### Cleanup (Always)

```bash
aws ec2 terminate-instances --instance-ids <id>
aws ec2 delete-security-group --group-id <sg-id>
aws ec2 delete-key-pair --key-name devops-key
aws ec2 delete-subnet --subnet-id <id>
aws ec2 detach-internet-gateway --vpc-id <vpc-id> --internet-gateway-id <igw-id>
aws ec2 delete-internet-gateway --internet-gateway-id <igw-id>
aws ec2 delete-vpc --vpc-id <vpc-id>
```

---

## Architecture

```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
Public Subnet (10.0.1.0/24)  ←  EC2 t2.micro + Docker
    │
VPC (10.0.0.0/16)
    │
Private Subnet (10.0.2.0/24)  ←  Databases (no internet)
```

---

## What I Learned

- IAM rule #1: never use root for daily work — always a dedicated IAM user
- Public subnet = route to internet gateway. Private subnet = no such route
- Security groups are stateful — allow inbound port 22, response traffic allowed automatically
- CLI-first forces understanding every parameter — no hiding behind a UI
- Always terminate resources — EC2 costs money even when idle
- Billing alarms are not optional — set them on day 1

---

## Pass Criteria

- [x] EC2 launched via CLI, SSH'd in, Docker container running
- [x] S3 bucket created, files uploaded/synced/downloaded
- [x] Custom VPC with public + private subnets
- [x] Billing alarm set at $1
- [x] All resources terminated — $0 bill