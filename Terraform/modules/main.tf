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
  

resource "digitalocean_droplet" "Ubuntu-server" {
  count  = 1
  image  = var.IMAGE
  name   = "web-server-Ubuntu"
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

resource "digitalocean_droplet" "CentOS-server" {
  count  = 1
  image  = "centos-stream-9-x64"
  name   = "web-server-centOS"
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


