provider "cloudflare" {
  version = "~> 1.18"
}

variable "cloudflare_zone" {
  type    = string
  default = "jaan.xyz"
}

resource "cloudflare_record" "cloud-a" {
  domain = "${var.cloudflare_zone}"
  name   = "cloud"
  type   = "A"
  value  = "178.128.251.243"
}

resource "cloudflare_record" "mail-a-1" {
  domain = "${var.cloudflare_zone}"
  name   = "mail"
  type   = "A"
  value  = "66.111.4.147"
}

resource "cloudflare_record" "mail-a-2" {
  domain = "${var.cloudflare_zone}"
  name   = "mail"
  type   = "A"
  value  = "66.111.4.148"
}

resource "cloudflare_record" "cloud-aaaa" {
  domain = "${var.cloudflare_zone}"
  name   = "cloud"
  type   = "AAAA"
  value  = "2a03:b0c0:2:f0::61:1001"
}

resource "cloudflare_record" "email_mg" {
  domain = "${var.cloudflare_zone}"
  name   = "email.mg"
  type   = "CNAME"
  value  = "mailgun.org"
}

resource "cloudflare_record" "fm1_domainkey" {
  domain = "${var.cloudflare_zone}"
  name   = "fm1._domainkey"
  type   = "CNAME"
  value  = "fm1.${var.cloudflare_zone}.dkim.fmhosted.com"
}

resource "cloudflare_record" "fm2_domainkey" {
  domain = "${var.cloudflare_zone}"
  name   = "fm2._domainkey"
  type   = "CNAME"
  value  = "fm2.${var.cloudflare_zone}.dkim.fmhosted.com"
}

resource "cloudflare_record" "fm3_domainkey" {
  domain = "${var.cloudflare_zone}"
  name   = "fm3._domainkey"
  type   = "CNAME"
  value  = "fm3.${var.cloudflare_zone}.dkim.fmhosted.com"
}

resource "cloudflare_record" "git" {
  domain = "${var.cloudflare_zone}"
  name   = "git"
  type   = "CNAME"
  value  = "cloud.${var.cloudflare_zone}"
}

resource "cloudflare_record" "root" {
  domain  = "${var.cloudflare_zone}"
  name    = "${var.cloudflare_zone}"
  type    = "CNAME"
  value   = "www.${var.cloudflare_zone}"
  proxied = true
}

resource "cloudflare_record" "mesmtp_domainkey" {
  domain = "${var.cloudflare_zone}"
  name   = "mesmtp._domainkey"
  type   = "CNAME"
  value  = "mesmtp.${var.cloudflare_zone}.dkim.fmhosted.com"
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

resource "cloudflare_record" "cloud-mx-1" {
  domain   = "${var.cloudflare_zone}"
  name     = "cloud"
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  priority = 10
}

resource "cloudflare_record" "cloud-mx-2" {
  domain   = "${var.cloudflare_zone}"
  name     = "cloud"
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  priority = 20
}

resource "cloudflare_record" "mx-1" {
  domain   = "${var.cloudflare_zone}"
  name     = "*"
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  priority = 10
}

resource "cloudflare_record" "mx-2" {
  domain   = "${var.cloudflare_zone}"
  name     = "*"
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  priority = 20
}

resource "cloudflare_record" "root-mx-1" {
  domain   = "${var.cloudflare_zone}"
  name     = "${var.cloudflare_zone}"
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  priority = 10
}

resource "cloudflare_record" "root-mx-2" {
  domain   = "${var.cloudflare_zone}"
  name     = "${var.cloudflare_zone}"
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  priority = 20
}

resource "cloudflare_record" "mail-mx-1" {
  domain   = "${var.cloudflare_zone}"
  name     = "mail"
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  priority = 10
}

resource "cloudflare_record" "mail-mx-2" {
  domain   = "${var.cloudflare_zone}"
  name     = "mail"
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  priority = 20
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

resource "cloudflare_record" "www-mx-1" {
  domain   = "${var.cloudflare_zone}"
  name     = "www"
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  priority = 10
}

resource "cloudflare_record" "www-mx-2" {
  domain   = "${var.cloudflare_zone}"
  name     = "www"
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  priority = 20
}

resource "cloudflare_record" "caldav" {
  domain = "${var.cloudflare_zone}"
  name   = "_caldavs._tcp"
  type   = "SRV"
  data = {
    "service"  = "_caldavs"
    "proto"    = "_tcp"
    "name"     = "${var.cloudflare_zone}"
    "priority" = 0
    "weight"   = 1
    "port"     = 443
    "target"   = "caldav.fastmail.com"
  }
  priority = 0
}

resource "cloudflare_record" "carddav" {
  domain = "${var.cloudflare_zone}"
  name   = "_carddavs._tcp"
  type   = "SRV"
  data = {
    "service"  = "_carddavs"
    "proto"    = "_tcp"
    "name"     = "${var.cloudflare_zone}"
    "priority" = 0
    "weight"   = 1
    "port"     = 443
    "target"   = "carddav.fastmail.com"
  }
  priority = 0
}

resource "cloudflare_record" "imap" {
  domain = "${var.cloudflare_zone}"
  name   = "_imaps._tcp"
  type   = "SRV"
  data = {
    "service"  = "_imaps"
    "proto"    = "_tcp"
    "name"     = "${var.cloudflare_zone}"
    "priority" = 0
    "weight"   = 1
    "port"     = 993
    "target"   = "imap.fastmail.com"
  }
  priority = 0
}

resource "cloudflare_record" "pop" {
  domain = "${var.cloudflare_zone}"
  name   = "_pop3s._tcp"
  type   = "SRV"
  data = {
    "service"  = "_pop3s"
    "proto"    = "_tcp"
    "name"     = "${var.cloudflare_zone}"
    "priority" = 10
    "weight"   = 1
    "port"     = 995
    "target"   = "pop.fastmail.com"
  }
  priority = 10
}

resource "cloudflare_record" "smtp" {
  domain = "${var.cloudflare_zone}"
  name   = "_submission._tcp"
  type   = "SRV"
  data = {
    "service"  = "_submission"
    "proto"    = "_tcp"
    "name"     = "${var.cloudflare_zone}"
    "priority" = 0
    "weight"   = 1
    "port"     = 587
    "target"   = "smtp.fastmail.com"
  }
  priority = 0
}

resource "cloudflare_record" "spf" {
  domain = "${var.cloudflare_zone}"
  name   = "${var.cloudflare_zone}"
  type   = "TXT"
  value  = "v=spf1 include:spf.messagingengine.com ?all"
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
