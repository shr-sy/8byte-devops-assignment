# React App Hosting with AWS S3 and CloudFront

This workspace provides a sample React application and Terraform configuration to host it on AWS using S3 and CloudFront.

## Contents

- `terraform/` - Terraform files to provision an S3 bucket, CloudFront distribution, and origin access identity.
- `react-app/` - Minimal React application built with Vite.

## Prerequisites

- AWS account and credentials configured locally (`aws configure`).
- Terraform installed locally.
- Node.js and npm installed.

## Steps

1. Deploy infrastructure:
   - `cd terraform`
   - `terraform init`
   - `terraform apply -var="bucket_name_prefix=my-react-cloudfront-site"`

2. Build the React app:
   - `cd ../react-app`
   - `npm install`
   - `npm run build`

3. Upload the build to S3:
   - `aws s3 sync dist s3://<bucket-name> --delete`

4. Invalidate CloudFront cache if needed:
   - `aws cloudfront create-invalidation --distribution-id <distribution-id> --paths "/*"`

## Notes

- The CloudFront distribution will be returned in Terraform outputs as `cloudfront_domain_name`.
- Use the `bucket_name` output for your S3 deployment target.
