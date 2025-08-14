/**
 * Static Website Module
 *
 * Provisions an S3 bucket configured for static website hosting and a
 * CloudFront distribution fronting it.  An origin access identity
 * (OAI) is used to restrict bucket access to CloudFront.  You must
 * synchronise your static content (from the docs/ directory) to the
 * bucket after `terraform apply`.  The CloudFront domain is output
 * for convenience.
 */

locals {
  bucket_name = "${var.project_name}-static-site"
}

resource "aws_s3_bucket" "static" {
  bucket        = local.bucket_name
  acl           = "private"
  force_destroy = true

  tags = {
    Project = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "static" {
  bucket = aws_s3_bucket.static.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.project_name} static site"
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.static.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static" {
  bucket = aws_s3_bucket.static.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_cloudfront_distribution" "static" {
  enabled             = true
  default_root_object = "index.html"

  origins {
    domain_name = aws_s3_bucket.static.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.static.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.static.id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Project = var.project_name
  }
}

output "bucket_name" {
  description = "S3 bucket name for the static site"
  value       = aws_s3_bucket.static.id
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.static.domain_name
}