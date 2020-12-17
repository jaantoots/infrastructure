resource "cloudflare_zone" "jaantoots_org" {
  zone = "jaantoots.org"
}

resource "cloudflare_record" "tll" {
  zone_id = cloudflare_zone.jaantoots_org.id
  name    = "tll"
  type    = "CNAME"
  value   = "tll-jaantoots-org.nsupdate.info"
}

resource "cloudflare_record" "_tll" {
  zone_id = cloudflare_zone.jaantoots_org.id
  name    = "*.tll"
  type    = "CNAME"
  value   = "tll.${cloudflare_zone.jaantoots_org.zone}"
}

module "fastmail_jaantoots_org" {
  source = "./fastmail"
  zone   = cloudflare_zone.jaantoots_org
}

resource "cloudflare_zone" "jaan_xyz" {
  zone = "jaan.xyz"
}

module "fastmail_jaan_xyz" {
  source         = "./fastmail"
  zone           = cloudflare_zone.jaan_xyz
  extra_mx_names = ["www", "cloud"]
}

resource "cloudflare_record" "cdn" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "cdn"
  type    = "CNAME"
  value   = "f002.backblazeb2.com"
  proxied = true
}

resource "cloudflare_page_rule" "allow_bucket" {
  zone_id  = cloudflare_zone.jaan_xyz.id
  target   = "https://${cloudflare_record.cdn.hostname}/file/jaan-public/*"
  priority = 2

  actions {
    ssl = "full"
  }
}

resource "cloudflare_page_rule" "disallow_others" {
  zone_id  = cloudflare_zone.jaan_xyz.id
  target   = "https://${cloudflare_record.cdn.hostname}/file/*/*"
  priority = 1

  actions {
    forwarding_url {
      url         = "https://secure.backblaze.com/404notfound"
      status_code = 302
    }
  }
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
