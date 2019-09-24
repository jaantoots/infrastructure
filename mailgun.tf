resource "cloudflare_record" "email_mg" {
  domain = "${var.cloudflare_zone}"
  name   = "email.mg"
  type   = "CNAME"
  value  = "mailgun.org"
}

resource "cloudflare_record" "mg-mx-1" {
  domain   = "${var.cloudflare_zone}"
  name     = "mg"
  type     = "MX"
  value    = "mxa.mailgun.org"
  priority = 10
}

resource "cloudflare_record" "mg-mx-2" {
  domain   = "${var.cloudflare_zone}"
  name     = "mg"
  type     = "MX"
  value    = "mxb.mailgun.org"
  priority = 10
}

resource "cloudflare_record" "mg-spf" {
  domain = "${var.cloudflare_zone}"
  name   = "mg"
  type   = "TXT"
  value  = "v=spf1 include:mailgun.org ~all"
}

resource "cloudflare_record" "smtp_domainkey_mg" {
  domain = "${var.cloudflare_zone}"
  name   = "smtp._domainkey.mg"
  type   = "TXT"
  value  = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9jJejlv+0qFFTwHNgJbz0cf+m2POJ1kDt6l3bGG41wFTG/fT8jp/yFWNgeXJeB0EPKGJK1H3DGobGjdfc0SS4kzXLkWTN7XIVbvl6U669Vw5EKDuP7XGdEARqata71O2jDwXUeCsZ5jIzPG/2FJtIl/90dUaEN2DtGdGgtdjuywIDAQAB"
}
