data "digitalocean_ssh_key" "aipc" {
  name = "MacSSH" //name of ssh-key in digital ocean
}

data "digitalocean_image" "mynginx" {
  name = "nginx"
}

resource "digitalocean_droplet" "mynginx" {
  name = "mynginx"
  image = data.digitalocean_image.mynginx.id
  region = var.digitalocean_region
  size = var.digitalocean_size

  ssh_keys = [ data.digitalocean_ssh_key.aipc.fingerprint ]
}

resource "local_file" "root_at_nginx" {
  filename = "root@${digitalocean_droplet.mynginx.ipv4_address}"
  content = ""
  file_permission = "0444"
}
