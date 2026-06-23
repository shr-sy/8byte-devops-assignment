variable "aws_region" {
  description = "AWS region where the S3 bucket and CloudFront distribution will be created."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name_prefix" {
  description = "Prefix used to create a unique S3 bucket name."
  type        = string
  default     = "react-cloudfront-site"
}

variable "environment" {
  description = "Deployment environment tag."
  type        = string
  default     = "dev"
}
