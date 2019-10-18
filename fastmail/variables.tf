variable "zone" {
  description = "Cloudflare Zone resource for creating records"
}

variable "extra_mx_names" {
  description = "Additional hostnames to create MX records for"
  type        = list(string)
  default     = []
}
