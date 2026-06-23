resource "random_string" "bucket_suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "aws_s3_bucket" "react_site" {
  bucket        = format("%s-%s", var.bucket_name_prefix, random_string.bucket_suffix.result)
  force_destroy = true

  tags = {
    Name        = "ReactStaticWebsite"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "react_site" {
  bucket                  = aws_s3_bucket.react_site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "Origin access identity for React CloudFront distribution"
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowCloudFrontServicePrincipal"

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.react_site.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "react_site_policy" {
  bucket = aws_s3_bucket.react_site.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_cloudfront_cache_policy" "react_cache_policy" {
  name = "react-cache-policy-${random_string.bucket_suffix.result}"

  default_ttl = 3600
  max_ttl     = 86400
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "react_origin_request_policy" {
  name = "react-origin-request-policy-${random_string.bucket_suffix.result}"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "none"
  }
}

resource "aws_cloudfront_distribution" "react_distribution" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.react_site.bucket_regional_domain_name
    origin_id   = "s3-react-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-react-origin"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    cache_policy_id        = aws_cloudfront_cache_policy.react_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.react_origin_request_policy.id
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_100"

  tags = {
    Name        = "ReactCloudFrontDistribution"
    Environment = var.environment
  }
}
