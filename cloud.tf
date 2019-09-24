resource "cloudflare_record" "cloud-a" {
  domain = "${var.cloudflare_zone}"
  name   = "cloud"
  type   = "A"
  value  = "178.128.251.243"
}

resource "cloudflare_record" "cloud-aaaa" {
  domain = "${var.cloudflare_zone}"
  name   = "cloud"
  type   = "AAAA"
  value  = "2a03:b0c0:2:f0::61:1001"
}

resource "cloudflare_record" "git" {
  domain = "${var.cloudflare_zone}"
  name   = "git"
  type   = "CNAME"
  value  = "cloud.${var.cloudflare_zone}"
}

resource "cloudflare_record" "photos" {
  domain = "${var.cloudflare_zone}"
  name   = "photos"
  type   = "CNAME"
  value  = "cloud.${var.cloudflare_zone}"
}

resource "cloudflare_record" "www" {
  domain  = "${var.cloudflare_zone}"
  name    = "www"
  type    = "CNAME"
  value   = "web.messagingengine.com"
  proxied = true
}

resource "cloudflare_record" "root" {
  domain  = "${var.cloudflare_zone}"
  name    = "${var.cloudflare_zone}"
  type    = "CNAME"
  value   = "www.${var.cloudflare_zone}"
  proxied = true
}
