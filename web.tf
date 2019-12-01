resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "www"
  type    = "CNAME"
  value   = "jaan-xyz.netlify.com"
}

resource "cloudflare_record" "root" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = cloudflare_zone.jaan_xyz.zone
  type    = "CNAME"
  value   = "www.${cloudflare_zone.jaan_xyz.zone}"
}
