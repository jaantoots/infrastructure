variable "acme_email" {
  description = "Email address used for ACME with Let's Encrypt"
}

variable "alerts_sms_number" {
  description = "Phone number for SMS alerts"
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
    galatea  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHKRtWhiRZZ5nepSxoj1k43kvnWps+EtS1KEam1mugv8 jaan@galatea"
  }
}

variable "ssh_keys_extra" {
  description = "Additional SSH public keys"
  default = {
    pass      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHh4q7pLAPP4hdqBwF69nvCyWQoDeH55PNBWWe3l7iZf pass@dumpling"
    gpslogger = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHIoP5UCYh1+K432lXEk7QhiPKVa23QEtASPXLhAf54zqRy3BYWvjJRSxaJHUqxGIvc7j1SY0PbeRG9idq+XZclxjFGTsOeLqFJ/eFIt8DFD/HNrDa5pwGH7MznAbD/kYxm641D+UMiBphROfDdMFN4bQv12Bj6Tamq+be29uTUAZABanhKndmKFm2cKs9C1G7Q4EaNMYfVn9Exzy6DzulwgW+8HhPrU5imeTlFNMJIn6DTCsdc8mZ6zUF+1sp5+gCST+GahNyFGqY8cgBs1UeJ5fcgyoe8Bnl/i5OGK931pWdz2IMs1dE/Gxmj6kvJvxdiOKtVUXO+nS5ebOTP/dH gpslogger@oneplus5t"
    ipad      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnl1th0qpYTEezbtfpYADpMXQPf9yfTtvgqFPhSbMnB+2/oDrPt9Dhl98F7aZdmfToEJ2B6k+MNAnsaO97v9vQG/nceTqm4Gnn4ygyW8kJ95q/qvonFGnPIfuy4/Of83y39IXrkXCO1xbwllz6FTDSGW3t35Uk4CJ0bfr96uMGO73G1j8Jlzv9OZTwcrKSm2VBFKdNqbaHx7y/npfpCFkX9MQq4C0efw+Q3OrM1ismCHbptEG2w5FR65klxpGLnath6eLSTqARfv4rEv2mxGkizXCb9o6AJ0J/BnlY5+sLO213bzAngdtJF0pOOQqp3WsfTjMxwIDdap4aUrNrWHmFtNwi0GfKuzJdwMcFGmx9T8IsHcIahUS2WK3xdP3uC21MLFyQS+l9lDCHN/T1dxWoyC0mzC027wAay/DRbuettTByXJHWSU6u1vndp5UxCdTa4AKqRK1sN/WgUJDRPLBe3X4VXxj3wll6UG7ZVQ3faNMVYOTGpnU5j73PsnCEq/M= jaan@ipad"
    iphone    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdsOVW5GRRPZlqd0nyzJ82b0NDoMgTRzyfPTq8Pn7pUWw3UQAT5a1TgEjqgRTVa1I1JSf+TtUi+UE2xajYjOcKcWRasLQC8Sa5fRwSOC96aaEJ02bdf6mJF/kZJ5TddGPaWKNFFFJemSrPSHl3D1AcHSmjhyNT8EBLiCa3zZuq+8OylHtMLCr4/VJvSGzVZJrnMTvEBmpH7cTe9beGVHqVkQMxtVf7nScFdOXTyNiQBQM1tgMS4I5lXZXR4QPATGnNsjqrymcRM8d1l2TBqPBl08PjlSGLRoWyzAOz9DemyUzdJcgF3hyv0uUQOmI6WO9Wt6a3iuVWOIeVATLAQTHySJgPw7jI0zV0tvC5i1LohDqo4I3LxG+UdAt6R8lwnfzr2XFEPZKm0yiKT9616BBOR990bqUfzoxfzLeAPHwMPqvyzRyhpQ8DvbOlmVOoHnsQOiBn3aNNWJ4qjriz2NAr39hkP+ZrnLOTMutoySFjqKDDzPPiUFNmdSyDKX011VM= jaan@iphone"
  }
}
