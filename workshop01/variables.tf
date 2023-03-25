variable bgg_backend_instance_count {
  type = number
  default = 3
}

variable docker_host {
  type = string
}

variable "digital_ocean_token" {
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
