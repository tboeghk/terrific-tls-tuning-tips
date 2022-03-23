# ---------------------------------------------------------------------
# ACME account for the website
# ---------------------------------------------------------------------
resource "tls_private_key" "ecdsa" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "acme_registration" "ecdsa" {
  account_key_pem = tls_private_key.ecdsa.private_key_pem
  email_address   = "acme@${local.dns_name}"
}

# ---------------------------------------------------------------------
# Create ACME certificate for location
# ---------------------------------------------------------------------
resource "acme_certificate" "ecdsa" {
  account_key_pem = tls_private_key.ecdsa.private_key_pem
  key_type        = "P256"
  common_name     = local.dns_name
  must_staple     = true

  dns_challenge {
    provider = "digitalocean"

    config = {
      DO_AUTH_TOKEN = var.do_token
    }
  }

  depends_on = [
    acme_registration.ecdsa
  ]

  lifecycle {
    ignore_changes = [
      dns_challenge[0].config
    ]
  }
}
