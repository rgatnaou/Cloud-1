
resource "local_file" "ansible_inventory" {
  content  = ""
  filename = "../ansible/inventory.ini"
}


resource "google_compute_instance" "cloud" {
  depends_on   = [local_file.ansible_inventory]
  count        = var.nb_vms
  name         = "vm-${count.index}"
  zone         = var.zone
  machine_type = var.machine_type

  tags = ["vms"]

  metadata = {
    ssh-keys = "${var.user}:${file(var.ssh_public_key)}"
  }

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }


  provisioner "remote-exec" {
    inline = ["cat /etc/os-release"]

    connection {
      type        = "ssh"
      user        = var.user
      host        = self.network_interface[0].access_config[0].nat_ip
      private_key = file(var.ssh_private_key)
    }
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "$PUBLIC_IP" >> $ANSIBLE_INVENTORY
      ssh-keyscan -H $PUBLIC_IP >> $KNOWN_HOSTS
    EOT
    environment = {
      PUBLIC_IP         = self.network_interface[0].access_config[0].nat_ip
      ANSIBLE_INVENTORY = local_file.ansible_inventory.filename
      KNOWN_HOSTS       = var.known_hosts_file
    }
  }


}

resource "google_compute_firewall" "rules" {
  name    = "my-firewall-rules"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vms"]
}

resource "null_resource" "execute_ansible_playbook" {
  depends_on = [google_compute_instance.cloud]

  provisioner "local-exec" {
    command = <<-EOT
      ansible-playbook -u ${var.user}  -i $inventory --private-key ${var.ssh_private_key} $playbook 
    EOT
    environment = {
      playbook  = "../ansible/roles.yml"
      inventory = "../ansible/inventory.ini"
    }
  }
}
