# Github
provider "github" {
  version    = "~> 2.2"
  token      = var.github_token
  individual = true
}

# Cloudflare for DNS
provider "cloudflare" {
  version   = "~> 2.0"
  api_token = var.cloudflare_api_token
}

# AWS
provider "aws" {
  version    = "~> 2.69"
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# DigitalOcean for servers
provider "digitalocean" {
  version = "~> 1.10"
  token   = var.do_token
}

provider "local" {
  version = "~> 1.4"
}
