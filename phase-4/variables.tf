variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Ubuntu"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "UdhyaamOS"
}