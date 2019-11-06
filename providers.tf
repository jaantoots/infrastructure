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

# DigitalOcean for servers
provider "digitalocean" {
  version = "~> 1.10"
  token   = "${var.do_token}"
}

provider "ignition" {
  version = "~> 1.1"
}
