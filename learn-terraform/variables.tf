variable "region" {
  description = "degitalocean region"
  default     = "nyc3"
}

variable "droplet_size" {
  description = "DigitalOcean droplet size"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "droplet_name" {
  description = "Name of the DigitalOcean droplet"
  default     = "Cloud-1"
}

variable "token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "ssh_key_id" {
  description = "SSH key ID for the DigitalOcean droplet"
  type        = string
  sensitive   = true
}

variable "pub_key" {
  description = "Path to the SSH private key"
  type        = string
  default     = "/home/rgatnaou/.ssh/id_rsa.pub"
}

variable "pvt_key" {
  description = "Path to the SSH private key"
  type        = string
  default     = "/home/rgatnaou/.ssh/id_rsa"
}