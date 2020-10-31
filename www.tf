resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "www"
  type    = "CNAME"
  value   = "jaantoots.gitlab.io"
}

resource "cloudflare_record" "www_verify" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "_gitlab-pages-verification-code.www"
  type    = "TXT"
  value   = "gitlab-pages-verification-code=cb1b2a6602a3505ca1d7a3942669533d"
}

resource "cloudflare_record" "root" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = cloudflare_zone.jaan_xyz.zone
  type    = "CNAME"
  value   = "www.${cloudflare_zone.jaan_xyz.zone}"
}

resource "cloudflare_record" "blog" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "blog"
  type    = "CNAME"
  value   = "jaantoots.gitlab.io"
}

resource "cloudflare_record" "blog_verify" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "_gitlab-pages-verification-code.blog"
  type    = "TXT"
  value   = "gitlab-pages-verification-code=839b7193500007e2920137217cea2545"
}
