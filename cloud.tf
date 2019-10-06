resource "linode_instance" "cloud" {
  label            = "arch-eu-central"
  region           = "eu-central"
  type             = "g6-nanode-1"
  authorized_users = ["${data.linode_profile.me.username}"]
  image            = "linode/arch"
}

resource "cloudflare_record" "cloud" {
  zone_id = "${data.cloudflare_zones.jaan_xyz.zones[0].id}"
  name    = "cloud"
  type    = "A"
  value   = "${linode_instance.cloud.ip_address}"
}

resource "cloudflare_record" "cloud6" {
  zone_id = "${data.cloudflare_zones.jaan_xyz.zones[0].id}"
  name    = "cloud"
  type    = "AAAA"
  value   = split("/", "${linode_instance.cloud.ipv6}")[0]
}

resource "cloudflare_record" "www" {
  zone_id = "${data.cloudflare_zones.jaan_xyz.zones[0].id}"
  name    = "www"
  type    = "CNAME"
  value   = "web.messagingengine.com"
  proxied = true
}

resource "cloudflare_record" "root" {
  zone_id = "${data.cloudflare_zones.jaan_xyz.zones[0].id}"
  name    = "${var.cloudflare_zone}"
  type    = "CNAME"
  value   = "www.${var.cloudflare_zone}"
  proxied = true
}
