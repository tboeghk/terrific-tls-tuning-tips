# ---------------------------------------------------------------------
# Create Server
# ---------------------------------------------------------------------

# Retrieve current debian image from DO
data "digitalocean_image" "this" {
  slug = "debian-11-x64"
}

# Create Server
resource "random_pet" "this" {
  keepers = {
    config = data.cloudinit_config.this.rendered
    distro = data.digitalocean_image.this.id
  }
}

# render user-data
data "cloudinit_config" "this" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = file("../cloud-init/default.yaml")
  }
  part {
    content_type = "text/cloud-config"
    content      = file("../cloud-init/nginx-host-tls-configurations.yaml")
  }
  part {
    content_type = "text/cloud-config"
    content = templatefile("../cloud-init/nginx.yaml", {
      tls_certs = local.certs
    })
  }
}

# create droplet
resource "digitalocean_droplet" "this" {
  image     = data.digitalocean_image.this.id
  name      = random_pet.this.id
  region    = var.do_region
  size      = "s-1vcpu-1gb"
  ipv6      = true
  ssh_keys  = [digitalocean_ssh_key.root.fingerprint]
  user_data = data.cloudinit_config.this.rendered
}

resource "digitalocean_firewall" "this" {
  name = "terrific-tls-tuning-tips"

  droplet_ids = [digitalocean_droplet.this.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443-450"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# assign servername
resource "digitalocean_record" "this" {
  domain = var.domain
  type   = "A"
  name   = "tls"
  value  = digitalocean_droplet.this.ipv4_address
  ttl    = 300
}
