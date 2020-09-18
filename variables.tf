variable "acme_email" {
  description = "Email address used for ACME with Let's Encrypt"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
}

variable "github_token" {
  description = "GitHub personal access token"
}

variable "github_owner" {
  description = "GitHub target account"
  default     = "jaantoots"
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
    pass      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8iLKgl/Wlnbf29Le3mBk4Aj1YwLE8Gotkr7R3oVD9+Wccb2ck1A2BpHeGedfLn3e01/C+rueAYK02oPsg4DBKC6NvA9luPJQ6yC1KqKg8GiWurOy8cARIuMI5saf/weTOxja0JiVmBTUgfg1yp6cgoJ/mN038PnhP37mKQMkfHRrFHbGcO4LZjBrhOwtlmgOiXPUMue1Dy/PGdhwBmAVPuzJnYvKYbD0x3Lr90qZDnzo0Usy1MQfMUJLsjRko10DYEnUdH869Sv8KxhN/9NyPogJULLwy67JjZQd0t9gegNl+oZNYTK+0MnLOFai0mEB8fzyUcGjOU8789OGcMXo3uaTE+f8GHqzqeNoc5g4+kYqxOsRodBq0StfDuzpXFvqoTE/OXDAdDGjt3Fm4KoSxNfKfGP+0coIYg79cS0CfgI4+ve0HuHia1DutMxovCSzwZxYbE3+ViMKY0boDUGqsgjf04e7MxwpUtvPvemz8TM3/3q9RBdc/UAWbbdyzD28XehP0gQDz6dkFDA6+Ipumoap3XMANVFiFCyHiNeS3CWn78etBuCy/ByCLa5uJWHWMBBauzL7ORFdOF4ROx/JwUSDETjKNZlia9ijDUjYmsPwCtBwvlQPVfibOBiUavdb0vNCDApDX9abHU1WPSb40llQzO9OzYUmzkn3ma3rniQ== pass@oneplus5t"
    gpslogger = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHIoP5UCYh1+K432lXEk7QhiPKVa23QEtASPXLhAf54zqRy3BYWvjJRSxaJHUqxGIvc7j1SY0PbeRG9idq+XZclxjFGTsOeLqFJ/eFIt8DFD/HNrDa5pwGH7MznAbD/kYxm641D+UMiBphROfDdMFN4bQv12Bj6Tamq+be29uTUAZABanhKndmKFm2cKs9C1G7Q4EaNMYfVn9Exzy6DzulwgW+8HhPrU5imeTlFNMJIn6DTCsdc8mZ6zUF+1sp5+gCST+GahNyFGqY8cgBs1UeJ5fcgyoe8Bnl/i5OGK931pWdz2IMs1dE/Gxmj6kvJvxdiOKtVUXO+nS5ebOTP/dH gpslogger@oneplus5t"
  }
}
