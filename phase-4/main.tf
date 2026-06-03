terraform {
    # --- NEW REMOTE BACKEND BLOCK ---
  backend "s3" {
    bucket = "udhyaamos-tfstate-aaryan-2026"
    key    = "phase4/terraform.tfstate"
    region = "ap-south-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --- 1. The Security Group ---
resource "aws_security_group" "devops_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH and HTTP traffic"

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

# --- 2. The EC2 Instance ---
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "${var.project_name}-Server"
  }
}

# --- 3. The New S3 Bucket ---
resource "aws_s3_bucket" "app_storage" {
  # S3 bucket names MUST be globally unique across all of AWS
  bucket = "${lower(var.project_name)}-storage-aaryan-2026"
}