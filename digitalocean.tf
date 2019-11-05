resource "digitalocean_ssh_key" "keys" {
  for_each   = var.ssh_keys
  name       = "${each.key}"
  public_key = "${each.value}"
}
