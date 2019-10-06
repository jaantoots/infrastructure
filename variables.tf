variable "cloudflare_zone" {
  type    = string
  default = "jaan.xyz"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API toker"
}

variable "github_token" {
  description = "GitHub personal access token"
}
