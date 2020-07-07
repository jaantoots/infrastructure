variable "acme_email" {
  description = "Email address used for ACME with Let's Encrypt"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
}

variable "github_token" {
  description = "GitHub personal access token"
}

variable "do_token" {
  description = "DigitalOcean personal access token"
}

variable "github_pkg_token" {
  description = "GitHub token for package registry acccess on deployments"
}

variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}

variable "ssh_keys" {
  description = "SSH public keys"
  default = {
    caracal  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMTSn9LSly4Gic5/s9JqYfvRTi+ZkwoZd/YTWaxmPA7 jaan@caracal"
    falstaff = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0xreG4XPAgqvyPqP58HYMGTjHKyh59XGDdOUgjVIEN jaan@falstaff"
    gpd      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMqraBY0913sVm751oqvM6tZoIQ/dBjOAIoZmukhsjo jaan@gpd"
  }
}
