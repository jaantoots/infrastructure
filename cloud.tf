resource "linode_instance" "cloud" {
  label            = "arch-eu-central"
  region           = "eu-central"
  type             = "g6-nanode-1"
  authorized_users = ["${data.linode_profile.me.username}"]
  image            = "linode/arch"
}

resource "cloudflare_record" "cloud" {
  domain = "${var.cloudflare_zone}"
  name   = "cloud"
  type   = "A"
  value  = "${linode_instance.cloud.ip_address}"
}

resource "cloudflare_record" "cloud6" {
  domain = "${var.cloudflare_zone}"
  name   = "cloud"
  type   = "AAAA"
  value  = split("/", "${linode_instance.cloud.ipv6}")[0]
}

resource "cloudflare_record" "www" {
  domain  = "${var.cloudflare_zone}"
  name    = "www"
  type    = "CNAME"
  value   = "web.messagingengine.com"
  proxied = true
}

resource "cloudflare_record" "root" {
  domain  = "${var.cloudflare_zone}"
  name    = "${var.cloudflare_zone}"
  type    = "CNAME"
  value   = "www.${var.cloudflare_zone}"
  proxied = true
}
