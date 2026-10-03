variable "region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name prefix for resource naming"
  type        = string
  default     = "8byte"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to deploy resources into"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "ami_id" {
  description = "AMI ID for the EC2 application server"
  type        = string
  default     = "ami-0f5ee92e2d63afc18"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "app_instance_count" {
  description = "Number of EC2 instances in the app tier"
  type        = number
  default     = 1
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "appadmin"
}

variable "db_password" {
  description = "RDS password. Use AWS Secrets Manager in production for security."
  type        = string
  sensitive   = true
  default     = "StrongPass123!"
}

variable "ingress_cidrs" {
  description = "Allowed CIDR blocks for inbound access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
