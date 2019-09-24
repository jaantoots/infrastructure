provider "cloudflare" {
  version = "~> 1.18"
}

variable "cloudflare_zone" {
  type    = string
  default = "jaan.xyz"
}
