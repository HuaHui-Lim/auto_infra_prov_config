variable "digitalocean_token" {
  type = string
  sensitive = true
}

variable "digitalocean_image" {
  type = string
  default = "ubuntu-20-04-x64"
}

variable "digitalocean_region" {
  type = string
  default = "sgp1"

}

variable "digitalocean_size" {
  type = string
  default = "s-1vcpu-2gb"
}
