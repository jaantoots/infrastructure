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

# Linode for servers
provider "linode" {
  version = "~> 1.8"
  token   = "${var.linode_token}"
}
