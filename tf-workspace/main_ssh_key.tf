# ---------------------------------------------------------------------
# Root keys for server access (access denied later anyway)
# ---------------------------------------------------------------------
resource "tls_private_key" "root" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "digitalocean_ssh_key" "root" {
  name       = local.dns_name
  public_key = tls_private_key.root.public_key_openssh
}
