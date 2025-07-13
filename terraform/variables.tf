variable "project" {
  type = string
}

variable "region" {
  default = "us-central1"
}


variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "boot_disk_image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "nb_vms" {
  type    = number
  default = 2
}

variable "ssh_private_key" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "known_hosts_file" {
  type = string
}
variable "user" {
  type    = string
  default = "ansible-user"
}