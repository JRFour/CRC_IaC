variable "cloudflare_zone_id" {
  type        = string
  description = "The Cloudflare zone ID for DNS records"
  default     = "3a7f62044f83e2a88fc3fddb3d90ca31"
}

# CNAME linking domain to AWS site via CloudFront
resource "cloudflare_record" "site_cname" {
  zone_id = var.cloudflare_zone_id
  name    = var.site_domain
  value   = aws_cloudfront_distribution.site_distribution.domain_name
  type    = "CNAME"

  ttl     = 1
  proxied = true
}

# CAA record allowing AWS to recognize domain for certificate creating
resource "cloudflare_record" "site_caa" {
  data = {
    flags = 0
    tag   = "issue"
    value = "amazonaws.com"
  }
  name    = "realewanderer.net"
  proxied = false
  ttl     = 1
  type    = "CAA"
  zone_id = var.cloudflare_zone_id
}

# AWS Certificate Validation Record
resource "cloudflare_record" "cert_record" {
  zone_id = var.cloudflare_zone_id
  ttl = 60
  
  for_each = {
    for dvo in aws_acm_certificate.site_cert.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
 
  name = each.value.name
  value = each.value.record
  type = each.value.type
}
