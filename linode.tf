resource "linode_sshkey" "keys" {
  for_each = var.ssh_keys
  label    = "${each.key}"
  ssh_key  = "${each.value}"
}

data "linode_profile" "me" {}
