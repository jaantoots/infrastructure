resource "cloudflare_record" "email_mg" {
  zone_id = "${var.zone.id}"
  name    = "email.mg"
  type    = "CNAME"
  value   = "mailgun.org"
}

resource "cloudflare_record" "mg-mx1" {
  zone_id  = "${var.zone.id}"
  name     = "mg"
  type     = "MX"
  value    = "mxa.mailgun.org"
  priority = 10
}

resource "cloudflare_record" "mg-mx2" {
  zone_id  = "${var.zone.id}"
  name     = "mg"
  type     = "MX"
  value    = "mxb.mailgun.org"
  priority = 10
}

resource "cloudflare_record" "mg-spf" {
  zone_id = "${var.zone.id}"
  name    = "mg"
  type    = "TXT"
  value   = "v=spf1 include:mailgun.org ~all"
}

resource "cloudflare_record" "domainkey_mg" {
  zone_id = "${var.zone.id}"
  name    = "${var.selector}._domainkey.mg"
  type    = "TXT"
  value   = "${var.domainkey}"
}
