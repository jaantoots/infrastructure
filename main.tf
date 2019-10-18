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

# Linode for servers
provider "linode" {
  version = "~> 1.8"
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
