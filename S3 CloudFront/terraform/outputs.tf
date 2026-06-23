output "bucket_name" {
  description = "Name of the S3 bucket created to host static assets."
  value       = aws_s3_bucket.react_site.bucket
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for the React site."
  value       = aws_cloudfront_distribution.react_distribution.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name for the React site."
  value       = aws_cloudfront_distribution.react_distribution.domain_name
}
