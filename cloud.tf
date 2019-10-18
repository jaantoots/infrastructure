resource "linode_instance" "cloud" {
  label            = "arch-eu-central"
  region           = "eu-central"
  type             = "g6-nanode-1"
  authorized_users = ["${data.linode_profile.me.username}"]
  image            = "linode/arch"
}

resource "cloudflare_record" "cloud" {
  zone_id = "${cloudflare_zone.jaan_xyz.id}"
  name    = "cloud"
  type    = "A"
  value   = "${linode_instance.cloud.ip_address}"
}

resource "cloudflare_record" "cloud6" {
  zone_id = "${cloudflare_zone.jaan_xyz.id}"
  name    = "cloud"
  type    = "AAAA"
  value   = split("/", "${linode_instance.cloud.ipv6}")[0]
}

resource "cloudflare_record" "www" {
  zone_id = "${cloudflare_zone.jaan_xyz.id}"
  name    = "www"
  type    = "CNAME"
  value   = "web.messagingengine.com"
  proxied = true
}

resource "cloudflare_record" "root" {
  zone_id = "${cloudflare_zone.jaan_xyz.id}"
  name    = "${cloudflare_zone.jaan_xyz.zone}"
  type    = "CNAME"
  value   = "www.${cloudflare_zone.jaan_xyz.zone}"
  proxied = true
}
