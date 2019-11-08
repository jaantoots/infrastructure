variable "zone" {
  description = "Cloudflare Zone resource for creating records"
}

variable "selector" {
  description = "DKIM selector from Mailgun"
  type        = string
}

variable "domainkey" {
  description = "DKIM public key from Mailgun"
  type        = string
}
