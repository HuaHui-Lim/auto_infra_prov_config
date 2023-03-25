resource "docker_network" "bgg_net" {
  name = "bgg_net"
}

resource "docker_volume" "bgg_volume" {
  name = "bgg_volume"
}

resource "docker_image" "bgg_database" {
  name = "chukmunnlee/bgg-database:v3.1"
}

resource "docker_container" "bgg_database" {
  name  = "bgg_database"
  image = docker_image.bgg_database.image_id
  networks_advanced {
    name = docker_network.bgg_net.name
  }
  volumes {
    container_path = "/var/lib/mysql"
    volume_name = docker_volume.bgg_volume.name
  }
  ports {
    internal = 3306
    external = 3306
  }
}

resource "docker_image" "bgg_backend" {
  name = "chukmunnlee/bgg-backend:v3"
}

resource "docker_container" "bgg_backend" {
  count = var.bgg_backend_instance_count
  name = "bgg_backend${count.index}"
  image = docker_image.bgg_backend.image_id
  ports {
      internal = 3000
      external = 3000 + count.index
  }
  networks_advanced {
    name = docker_network.bgg_net.name
  }
  env = [
    "BGG_DB_USER=root",
    "BGG_DB_PASSWORD=changeit",
    "BGG_DB_HOST=${docker_container.bgg_database.name}"
  ]
}

resource "local_file" "nginx-conf" {
  filename = "nginx.conf"
  content = templatefile("sample.nginx.conf.tfpl", {
    docker_host = var.docker_host,
    ports = docker_container.bgg_backend[*].ports[0].external
  })
}

data "digitalocean_ssh_key" "aipc" {
  name = "MacSSH" //name of ssh-key in digital ocean
}

resource "digitalocean_ssh_key" "host_key" {
  name = "fred_key"
  public_key = file(var.ssh_public_key)
}

resource "digitalocean_droplet" "reverse_proxy" {
  image  = "ubuntu-20-04-x64"
  name   = "reverse-proxy"
  region = "sgp1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [ data.digitalocean_ssh_key.aipc.fingerprint, digitalocean_ssh_key.host_key.fingerprint ]
  connection {
    type = "ssh"
    user = "root"
    private_key = file(var.ssh_private_key)
    host = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "apt update -y",
      "apt upgrade -y",
      "apt install nginx -y",
    ]
  }

  provisioner "file" {
    source = local_file.nginx-conf.filename
    destination = "/etc/nginx/nginx.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl enable nginx",
      "systemctl restart nginx",
    ]
  }
}

resource "local_file" "root_at_reverse_proxy" {
  filename = "root@${digitalocean_droplet.reverse_proxy.ipv4_address}"
  content = ""
  file_permission = "0444"
}

output "reverse_proxy_ipv4" {
  value = digitalocean_droplet.reverse_proxy.ipv4_address
}

