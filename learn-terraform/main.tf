# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


provider "digitalocean" {
  token = var.token
}




resource "digitalocean_droplet" "ubuntu" {
  name     = var.droplet_name
  image    = "ubuntu-22-04-x64" # Known good slug
  region   = var.region
  size     = var.droplet_size
  ssh_keys = [var.ssh_key_id]
  provisioner "local-exec" {
    command = <<-EOT
      echo "[deploy]\n${self.ipv4_address} ansible_user=root ansible_ssh_private_key_file=$private_key"  > ../ansible/inventory.ini
      ansible-playbook -i ../ansible/inventory.ini ../ansible/roles.yml
    EOT
    environment = {

      private_key="/home/rgatnaou/.ssh/id_rsa"
    }
  }
}

