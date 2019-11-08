resource "cloudflare_zone" "jaantoots_org" {
  zone = "jaantoots.org"
}

resource "cloudflare_record" "auganite" {
  zone_id = "${cloudflare_zone.jaantoots_org.id}"
  name    = "auganite"
  type    = "CNAME"
  value   = "auganite-jaantoots-org.nsupdate.info"
}

module "fastmail_jaantoots_org" {
  source         = "./fastmail"
  zone           = cloudflare_zone.jaantoots_org
  extra_mx_names = ["www", "cloud"]
}

module "mailgun_jaantoots_org" {
  source    = "./mailgun"
  zone      = cloudflare_zone.jaantoots_org
  selector  = "krs"
  domainkey = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDhQNpN9thb0zIz9JCA+QzM2YFRnPYE+3Tv6Q33/UwBKbTDbevhkMJ7e1QBjAWr6AXOO/VpYcaTpJJSLA2xdNzTyhp8kWyVnjcsUc0ifYXoXPEziY1p4qTDFPLrusfmAkPQzSRMdlFWhN00Lm2KKCrRjZ+a60YiUYDSUmTMiohbjQIDAQAB"
}

resource "cloudflare_zone" "jaan_xyz" {
  zone = "jaan.xyz"
}

module "fastmail_jaan_xyz" {
  source         = "./fastmail"
  zone           = cloudflare_zone.jaan_xyz
  extra_mx_names = ["www", "cloud"]
}

module "mailgun_jaan_xyz" {
  source    = "./mailgun"
  zone      = cloudflare_zone.jaan_xyz
  selector  = "smtp"
  domainkey = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9jJejlv+0qFFTwHNgJbz0cf+m2POJ1kDt6l3bGG41wFTG/fT8jp/yFWNgeXJeB0EPKGJK1H3DGobGjdfc0SS4kzXLkWTN7XIVbvl6U669Vw5EKDuP7XGdEARqata71O2jDwXUeCsZ5jIzPG/2FJtIl/90dUaEN2DtGdGgtdjuywIDAQAB"
}

resource "cloudflare_zone" "jstd_io" {
  zone = "jstd.io"
}

module "fastmail_jstd_io" {
  source = "./fastmail"
  zone   = cloudflare_zone.jstd_io
}

resource "cloudflare_zone" "jstd_eu" {
  zone = "jstd.eu"
}
