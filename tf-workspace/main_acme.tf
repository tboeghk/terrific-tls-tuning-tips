# ---------------------------------------------------------------------
# ACME account for the website
# ---------------------------------------------------------------------
resource "tls_private_key" "ecdsa" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "acme_registration" "ecdsa" {
  account_key_pem = tls_private_key.ecdsa.private_key_pem
  email_address   = "acme@${local.dns_name}"
}

resource "acme_registration" "rsa" {
  account_key_pem = tls_private_key.rsa.private_key_pem
  email_address   = "acme@${local.dns_name}"
}

# ---------------------------------------------------------------------
# Create ACME certificate for location
# ---------------------------------------------------------------------
locals {
  cert_definitions = {
    ecdsa = {
      key_type        = "P256"
      account_key_pem = tls_private_key.ecdsa.private_key_pem
    },
    rsa2048 = {
      key_type        = "2048"
      account_key_pem = tls_private_key.rsa.private_key_pem
    },
    rsa4096 = {
      key_type        = "4096"
      account_key_pem = tls_private_key.rsa.private_key_pem
    }
  }
  certs = [
    for name, definiton in local.cert_definitions : {
      name            = name
      private_key_pem = acme_certificate.this[name].private_key_pem
      certificate_pem = acme_certificate.this[name].certificate_pem
      issuer_pem      = acme_certificate.this[name].issuer_pem
    }
  ]
}

resource "acme_certificate" "this" {
  for_each = local.cert_definitions

  account_key_pem = each.value.account_key_pem
  key_type        = each.value.key_type
  common_name     = local.dns_name

  dns_challenge {
    provider = "digitalocean"

    config = {
      DO_AUTH_TOKEN = var.do_token
    }
  }

  depends_on = [
    acme_registration.ecdsa,
    acme_registration.rsa
  ]

  lifecycle {
    ignore_changes = [
      dns_challenge[0].config
    ]
  }
}
