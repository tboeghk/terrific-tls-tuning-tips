# ---------------------------------------------------------------------
# ACME account for the website
# ---------------------------------------------------------------------
locals {
  dns_name = "tls.${var.domain}"
}