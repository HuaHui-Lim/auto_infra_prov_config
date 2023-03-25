variable "digitalocean_token" {
  type = string
  sensitive = true
}

variable "ssh_private_key" {
  type = string
  sensitive = true
}

variable "ssh_public_key" {
  type = string
}

variable "codeserver-password" {
  type = string
  sensitive = true
}

variable "digitalocean_size" {
  type = string
  default = "s-1vcpu-2gb"
}

variable "digitalocean_region" {
  type = string
  default = "sgp1"
}