# Github
provider "github" {
  version    = "~> 2.2"
  token      = "${var.github_token}"
  individual = true
}

# Cloudflare for DNS
provider "cloudflare" {
  version   = "~> 2.0"
  api_token = "${var.cloudflare_api_token}"
}

resource "cloudflare_zone" "jaan_xyz" {
  zone = "jaan.xyz"
}

module "fastmail_jaan_xyz" {
  source         = "./fastmail"
  zone           = cloudflare_zone.jaan_xyz
  extra_mx_names = ["www", "cloud"]
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

# Linode for servers
provider "linode" {
  version = "~> 1.8"
  token   = "${var.linode_token}"
}

resource "linode_sshkey" "caracal" {
  label   = "caracal"
  ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMTSn9LSly4Gic5/s9JqYfvRTi+ZkwoZd/YTWaxmPA7 jaan@caracal"
}

resource "linode_sshkey" "falstaff" {
  label   = "falstaff"
  ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0xreG4XPAgqvyPqP58HYMGTjHKyh59XGDdOUgjVIEN jaan@falstaff"
}

data "linode_profile" "me" {}
