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
