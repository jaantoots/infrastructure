resource "cloudflare_record" "mail-a1" {
  zone_id = var.zone.id
  name    = "mail"
  type    = "A"
  value   = "66.111.4.147"
}

resource "cloudflare_record" "mail-a2" {
  zone_id = var.zone.id
  name    = "mail"
  type    = "A"
  value   = "66.111.4.148"
}

locals {
  mx_names = concat(["*", var.zone.zone, "mail"], var.extra_mx_names)
}

resource "cloudflare_record" "mx1" {
  for_each = toset(local.mx_names)
  zone_id  = var.zone.id
  name     = each.value
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  priority = 10
}

resource "cloudflare_record" "mx2" {
  for_each = toset(local.mx_names)
  zone_id  = var.zone.id
  name     = each.value
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  priority = 20
}

resource "cloudflare_record" "fm1_domainkey" {
  zone_id = var.zone.id
  name    = "fm1._domainkey"
  type    = "CNAME"
  value   = "fm1.${var.zone.zone}.dkim.fmhosted.com"
}

resource "cloudflare_record" "fm2_domainkey" {
  zone_id = var.zone.id
  name    = "fm2._domainkey"
  type    = "CNAME"
  value   = "fm2.${var.zone.zone}.dkim.fmhosted.com"
}

resource "cloudflare_record" "fm3_domainkey" {
  zone_id = var.zone.id
  name    = "fm3._domainkey"
  type    = "CNAME"
  value   = "fm3.${var.zone.zone}.dkim.fmhosted.com"
}

resource "cloudflare_record" "mesmtp_domainkey" {
  zone_id = var.zone.id
  name    = "mesmtp._domainkey"
  type    = "CNAME"
  value   = "mesmtp.${var.zone.zone}.dkim.fmhosted.com"
}

resource "cloudflare_record" "spf" {
  zone_id = var.zone.id
  name    = var.zone.zone
  type    = "TXT"
  value   = "v=spf1 include:spf.messagingengine.com ?all"
}

resource "cloudflare_record" "caldav" {
  zone_id = var.zone.id
  name    = "_caldavs._tcp"
  type    = "SRV"
  data = {
    "service"  = "_caldavs"
    "proto"    = "_tcp"
    "name"     = var.zone.zone
    "priority" = 0
    "weight"   = 1
    "port"     = 443
    "target"   = "caldav.fastmail.com"
  }
  priority = 0
}

resource "cloudflare_record" "carddav" {
  zone_id = var.zone.id
  name    = "_carddavs._tcp"
  type    = "SRV"
  data = {
    "service"  = "_carddavs"
    "proto"    = "_tcp"
    "name"     = var.zone.zone
    "priority" = 0
    "weight"   = 1
    "port"     = 443
    "target"   = "carddav.fastmail.com"
  }
  priority = 0
}

resource "cloudflare_record" "imap" {
  zone_id = var.zone.id
  name    = "_imaps._tcp"
  type    = "SRV"
  data = {
    "service"  = "_imaps"
    "proto"    = "_tcp"
    "name"     = var.zone.zone
    "priority" = 0
    "weight"   = 1
    "port"     = 993
    "target"   = "imap.fastmail.com"
  }
  priority = 0
}

resource "cloudflare_record" "pop" {
  zone_id = var.zone.id
  name    = "_pop3s._tcp"
  type    = "SRV"
  data = {
    "service"  = "_pop3s"
    "proto"    = "_tcp"
    "name"     = var.zone.zone
    "priority" = 10
    "weight"   = 1
    "port"     = 995
    "target"   = "pop.fastmail.com"
  }
  priority = 10
}

resource "cloudflare_record" "smtp" {
  zone_id = var.zone.id
  name    = "_submission._tcp"
  type    = "SRV"
  data = {
    "service"  = "_submission"
    "proto"    = "_tcp"
    "name"     = var.zone.zone
    "priority" = 0
    "weight"   = 1
    "port"     = 587
    "target"   = "smtp.fastmail.com"
  }
  priority = 0
}
