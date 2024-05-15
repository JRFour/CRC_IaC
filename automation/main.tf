# DevOps Cloud Resume Challenge
# Author: John Reale IV
# Project Start: 5 May 2024
# 

#
# Configuring the Providers called for in terraform.tf
#

provider "aws" {
  region = var.aws_region
}

provider "cloudflare" {}


#
# Creating AWS S3 Static Site
#

# Bucket Setup
resource "aws_s3_bucket" "site" {
  bucket = var.site_domain
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ACL configuration
resource "aws_s3_bucket_acl" "site" {
  bucket = aws_s3_bucket.site.id

  acl = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.site,
    aws_s3_bucket_public_access_block.site
  ]
}

# Website setup
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "site" {
  bucket = aws_s3_bucket.site.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.site.arn,
          "${aws_s3_bucket.site.arn}/*",
        ]
      },
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.site
  ]
}

locals {
  # Mapping MIME types to file extensions
  mime_types = {
    ".html" = "text/html"
    ".png"  = "image/png"
    ".jpg"  = "image/jpg"
    ".gif"  = "image/gif"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
  }

  s3_origin_id = "CRC-S3-Origin"
}

# Website Files weren't uploaded to bucket - probably because it was run on HCP Terraform not locally
## Adding website files to bucket
#resource "aws_s3_object" "build" {
#  for_each = fileset("../website/", "**")
#  bucket = aws_s3_bucket.site.id
#  key = each.value
#  source = "../website/${each.value}"
#  etag = filemd5("../website/${each.value}")
#  acl = "public-read"
#  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), null)
#}


#
# Creating CloudFront Distribution
#

resource "aws_cloudfront_distribution" "site_distribution" {
  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id = local.s3_origin_id
  }

  aliases = ["static.realewanderer.net"]
  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site_cert.arn
    ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  depends_on = [
    aws_acm_certificate.site_cert,
  ]
}


# AWS Certificate Creation
resource "aws_acm_certificate" "site_cert" {
  domain_name = var.site_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# AWS Certificate Validation
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.site_cert.arn
  validation_record_fqdns = [for record in cloudflare_record.cert_record : record.hostname]
}

