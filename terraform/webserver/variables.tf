variable "do_token" {
  default = ""
}

variable "region" {
  default = ""
}

variable "ubuntu-image" {
  default = ""
}

variable "size"{
  default = ""
}

variable "resize_disk" {
  default = false
}

variable "ssh_keys" {
  type    = list(string)
  default = []
}

variable "prefix" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "domain" {
  default = ""
}

variable "record" {
  default = ""
}