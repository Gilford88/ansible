terraform {
  required_providers {
  digitalocean = {
    source = "digitalocean/digitalocean"
    version = "~> 2.0"
    }
  }
}

variable "COUNT" {
    }

variable "IMAGE" {
    }

variable "REGION" {
    }

variable "SSH_FINGERPRINT" {
    }
variable "PVT_KEY" {
    }
  

resource "digitalocean_droplet" "web_server" {
  count  = var.COUNT
  image  = var.IMAGE
  name   = "web-server-${count.index + 1}"
  region = var.REGION
  size   = "s-1vcpu-1gb"
  ssh_keys = [var.SSH_FINGERPRINT]
  tags   = ["Web-server"]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = "${file(var.PVT_KEY)}"
    timeout = "2m"
  }
}

  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt install ansible -y",
      "useradd james"
      "echo 'james  ALL=(ALL:ALL) ALL' >> /etc/sudoers"
    ]
  }

resource "digitalocean_droplet" "ansible_server" {
  count  = 1
  image  = var.IMAGE
  name   = "ansible-host"
  region = var.REGION
  size   = "s-1vcpu-1gb"
  ssh_keys = [var.SSH_FINGERPRINT]
  tags   = ["Web-server"]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = "${file(var.PVT_KEY)}"
    timeout = "2m"
  }

    provisioner "remote-exec" {
    inline = [
      "useradd james",
      "echo /'james  ALL=(ALL:ALL) ALL/' >> /etc/sudoers"
    ]
  }

}

output "server-ids" {
  value = digitalocean_droplet.web_server[*].id
}

output "server-ips" {
  value = digitalocean_droplet.web_server[*].ipv4_address
}

