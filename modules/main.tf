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


  provisioner "remote-exec" {
    inline = [
      "apt install wget unzip apache2 -y",
      "systemctl start apache2",
      "systemctl enable apache2",
      "wget https://www.tooplate.com/zip-templates/2117_infinite_loop.zip",
      "unzip -o 2117_infinite_loop.zip",
      "cp -r 2117_infinite_loop/* /var/www/html/",
      "systemctl restart apache2"
    ]
  }

}

output "server-ids" {
  value = digitalocean_droplet.web_server[*].id
}

output "server-ips" {
  value = digitalocean_droplet.web_server[*].ipv4_address
}

