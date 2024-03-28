terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.DO_TOKEN
}

resource "digitalocean_ssh_key" "default" {
  name       = "Terraform key pair"
  public_key = file("dovekey.pub")
}

module "droplet" {
source = "./modules"
COUNT = var.COUNT
IMAGE = var.IMAGE
REGION = var.REGION
SSH_FINGERPRINT = var.SSH_FINGERPRINT
PVT_KEY = var.PVT_KEY
}


output "server-ids" {
  value = "${module.droplet.server-ids}"
}

output "server-ips" {
  value = "${module.droplet.server-ips}"
}



