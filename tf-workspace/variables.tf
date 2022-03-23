# read from secrets.auto.tfvars
variable "do_token" {}

# customizable
variable "do_region" {
  default = "fra1"
}
variable "domain" {
  default = "fra1.o11ystack.org"
}
