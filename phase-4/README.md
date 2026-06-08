# Phase 4 — Infrastructure as Code — Terraform

> **Goal:** Translate manual AWS CLI architecture into version-controlled, declarative HCL.
> Duration: Week 5 · Days 27–33 · ~5 hrs/day

---

## File Structure

```
phase-4/
├── main.tf          # Resource definitions
├── variables.tf     # Input variable declarations
├── outputs.tf       # Output value definitions
├── terraform.tfvars # Actual values (gitignored)
└── README.md
```

---

## Core Files

### `main.tf` — Resource Definitions

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "aaryan-tfstate-2026"
    key    = "phase4/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "devops_sg" {
  name        = "${var.project_name}-sg"
  description = "DevOps security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devops_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name    = "${var.project_name}-ec2"
    Project = var.project_name
  }
}

resource "aws_s3_bucket" "devops_bucket" {
  bucket = var.bucket_name
  tags = {
    Project = var.project_name
  }
}
```

### `variables.tf`

```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Amazon Machine Image ID"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "cloud-ops"
}

variable "bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
}
```

### `outputs.tf`

```hcl
output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.devops_ec2.public_ip
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.devops_ec2.id
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.devops_bucket.bucket
}
```

---

## Terraform Workflow

```bash
# 1. Initialise — download providers, configure S3 backend
terraform init

# 2. Format code
terraform fmt

# 3. Validate syntax
terraform validate

# 4. Dry run — see what will change
terraform plan

# 5. Deploy
terraform apply -var-file="terraform.tfvars"

# 6. Check outputs
terraform output
terraform output ec2_public_ip

# 7. View state
terraform state list
terraform state show aws_instance.devops_ec2

# 8. Sync state with reality
terraform refresh

# 9. Clean teardown
terraform destroy -var-file="terraform.tfvars"
```

---

## Key Concepts

| Concept | What it means |
|---------|---------------|
| `terraform.tfstate` | Terraform's brain — maps config to real AWS resources |
| `terraform plan` | Dry run — shows drift between desired and actual state |
| Remote state (S3) | Shared state for team workflows — everyone sees the same state |
| `variables.tf` | No hardcoded values — configs are reusable and safe |
| `terraform.tfvars` | Actual values — **always gitignored**, may contain secrets |
| `terraform refresh` | Syncs state with reality after manual AWS changes |

---

## What I Learned

- Terraform state is everything — never manually edit `.tfstate`
- `terraform plan` shows exactly what will change before touching anything
- Variables + tfvars make configs reusable across environments (dev/staging/prod)
- Remote state in S3 is essential — local state breaks in team workflows
- `terraform destroy` is as important as `terraform apply` — always clean up
- If someone manually deletes a resource, `terraform plan` detects the drift and recreates it

---

## Pass Criteria

- [x] EC2 + S3 + security group created via `terraform apply`
- [x] No hardcoded values — everything uses variables
- [x] Outputs print EC2 IP after apply
- [x] Remote state configured in S3
- [x] `terraform destroy` removes all resources cleanly