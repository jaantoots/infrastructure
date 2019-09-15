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

resource "linode_instance" "cloud" {
  label            = "arch-eu-central"
  region           = "eu-central"
  type             = "g6-nanode-1"
  authorized_users = ["${data.linode_profile.me.username}"]
  image            = "linode/arch"
}

output "cloud" {
  value = "${linode_instance.cloud.ip_address}"
}
