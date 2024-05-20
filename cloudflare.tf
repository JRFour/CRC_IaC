#
# Setting DNS records in CloudFlare
#

data "cloudflare_zones" "domain" {
  filter {
    name = var.site_domain
  }
}

# CNAME linking domain to AWS site via CloudFront
resource "cloudflare_record" "site_cname" {
  zone_id = "3a7f62044f83e2a88fc3fddb3d90ca31"
        #data.cloudflare_zones.domain.zones[0].id
  name    = var.site_domain
  value   = aws_cloudfront_distribution.site_distribution.domain_name
	#aws_s3_bucket_website_configuration.site.website_endpoint
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
  zone_id = "3a7f62044f83e2a88fc3fddb3d90ca31"
}

# AWS Certificate Validation Record
resource "cloudflare_record" "cert_record" {
  zone_id = "3a7f62044f83e2a88fc3fddb3d90ca31"
  #allow_overwrite = true
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
