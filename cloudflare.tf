provider "cloudflare" {
	# token pulled from $CLOUDFLARE_API_TOKEN
}

variable "zone_id" {
	default = "3a7f62044f83e2a88fc3fddb3d90ca31"
}

variable "account_id" {
	default = "de5f7b6479c7910dc1f85491762ebd7c"
}

variable "domain" {
	default = "realewanderer.net"
}

resource "cloudflare_record" "test" {
	zone_id = var.zone_id
	name = "test"
	value = "153.92.7.14"
	type = "A"
	proxied = true
}
