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
