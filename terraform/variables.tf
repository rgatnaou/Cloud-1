variable "project" {
  default = "ultra-aquifer-463909-b1"
}

variable "region" {
  default = "us-central1"
}

variable "nb_vms" {
  default = 1
}

variable "ssh_private_key" {
  type    = string
  default = "/home/babkar/.ssh/gcp"
}

variable "ssh_public_key" {
  type    = string
  default = "/home/babkar/.ssh/gcp.pub"
}


variable "user" {
  type    = string
  default = "root"
}