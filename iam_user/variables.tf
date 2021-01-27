variable "name" {
  type = string
}

variable "path" {
  type    = string
  default = "/"
}

variable "groups" {
  type    = list(string)
  default = []
}
