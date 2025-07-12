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


    provisioner "remote-exec" {
        inline = ["echo Done!"]

        connection {
          host        = self.ipv4_address
          type        = "ssh"
          user        = "root"
          private_key = file(var.pvt_key)
        }
      }

      provisioner "local-exec" {
        # command = "sleep 20 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' ../ansible/roles.yml"
        command = <<EOT 
                echo '[dep
                ${self.ipv4_address} ansible_user=root ansible_ssh_private_key_file=${var.pvt_key}' > ../ansible/inventory.ini && \
                sleep 20 && \
                ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory.ini ../ansible/roles.yml -J"
              EOT
      }
  
  # provisioner "local-exec" {
  #   command = <<-EOT
  #     echo "[deploy]\n${self.ipv4_address} ansible_user=root ansible_ssh_private_key_file=$private_key"  > ../ansible/inventory.ini
  #     sleep 15
  #     ansible-playbook -i ../ansible/inventory.ini ../ansible/roles.yml
  #   EOT
  #   environment = {

  #     private_key="/home/rgatnaou/.ssh/id_rsa"
  #   }
  # }
  # provisioner "local-exec" {
  #     command = <<-EOT
  #       echo "[deploy]
  #   ${self.ipv4_address} ansible_user=root ansible_ssh_private_key_file=$private_key" > ../ansible/inventory.ini

  #       echo "Waiting for SSH to become available on ${self.ipv4_address}..."
  #       for i in {1..20}; do
  #         if nc -z ${self.ipv4_address} 22; then
  #           echo "SSH is up!"
  #           break
  #         fi
  #         echo "Still waiting for SSH... ($i)"
  #         sleep 5
  #       done

  #       ansible-playbook -i ../ansible/inventory.ini ../ansible/roles.yml
  #     EOT

  #     environment = {
  #       private_key = "/home/rgatnaou/.ssh/id_rsa"
  #     }
  #   }

}


