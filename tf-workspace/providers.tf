terraform {
  required_version = "~> 1.1"

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.18.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.1.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 3.1.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.7.0"
    }
  }
}

provider "digitalocean" {
  token   = var.do_token
}

provider "acme" {
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}
