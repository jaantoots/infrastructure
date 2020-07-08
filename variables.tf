variable "acme_email" {
  description = "Email address used for ACME with Let's Encrypt"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
}

variable "github_token" {
  description = "GitHub personal access token"
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

variable "ssh_keys_extra" {
  description = "Additional SSH public keys"
  default = {
    oneplus5t = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw/nzdTrfL01ZEeFn3Os7XCOb8prZWp+5h5m5pfpDKX8qUoI+cELF4p+u8bkzSONFBoFYAbvzRgW9QkBCRnopyLY4c7q5R+Rxy4CqwhfaLzFL1Ova8uBsEhEHhEwhwX+kWG/hDCbq6AppStw+JCNkWOcj0fjntfucGoqRbrv9kS4+y1JjgvFMQeHaKif0ZILb/SivhHGMaJpApyHWx8kmkDm0AFjb3Gx0BZBX1atQHi+l8yfcJpDMwm50M3KH1PDWL1GGleqjV+yQ5XGlh2VXV7CyUTrE/yRnchl6M+831Btq1SvrfmagZ46xRDSFEKWvsevYC72HvwfpcxsYv5yPTETGnI2/vE2lAihI44vg8u1uJ3TkPJKfu8zXRUy3VAwOaSQNc5J09RSQY2x9UMCNq7XUGTlz1p1BdzMulpJRMj7oZI0wqzqsvNGRvG+jw8lxei1k38OztTXvDbf7P7/mM77jYLC7uorWASFQ3D5TgXDnb8dpRo8h8BX65UlE6pG3bbndI5wKrqdjt/mACDdYBzPkc8dRz7MYs1HYFnv8BbzKLRNr6qMAsEj5Q9nNtKsfd2ZONE6Ce+fHrIFMMHyPTikFqyXm8/65YVW0OemP3I93GJdkvRevkb8hq380ABwGcS+EwyV5EIfEI0bUWJFw2/ZQo2Y+988AfJ9P0qeBHWw== jaan@oneplus5t"
    gpslogger = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHIoP5UCYh1+K432lXEk7QhiPKVa23QEtASPXLhAf54zqRy3BYWvjJRSxaJHUqxGIvc7j1SY0PbeRG9idq+XZclxjFGTsOeLqFJ/eFIt8DFD/HNrDa5pwGH7MznAbD/kYxm641D+UMiBphROfDdMFN4bQv12Bj6Tamq+be29uTUAZABanhKndmKFm2cKs9C1G7Q4EaNMYfVn9Exzy6DzulwgW+8HhPrU5imeTlFNMJIn6DTCsdc8mZ6zUF+1sp5+gCST+GahNyFGqY8cgBs1UeJ5fcgyoe8Bnl/i5OGK931pWdz2IMs1dE/Gxmj6kvJvxdiOKtVUXO+nS5ebOTP/dH gpslogger@oneplus5t"
  }
}
