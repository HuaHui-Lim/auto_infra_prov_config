data "digitalocean_ssh_key" "aipc" {
  name = "MacSSH" //name of ssh-key in digital ocean
}

data "digitalocean_image" "codeserver" {
  name = "codeserver"
}

#resource "digitalocean_ssh_key" "host_key" {
data "digitalocean_ssh_key" "host_key" {
 name = "fred_key_2"
# public_key = file(var.ssh_public_key)
}

resource "digitalocean_droplet" "codeserver" {
  name = "codeserver"
  image = data.digitalocean_image.codeserver.id
  region = var.digitalocean_region
  size = var.digitalocean_size
  ssh_keys = [ data.digitalocean_ssh_key.aipc.fingerprint, data.digitalocean_ssh_key.host_key.fingerprint  ]
}

resource "local_file" "root_at_codeserver" {
  filename = "root@${digitalocean_droplet.codeserver.ipv4_address}"
  content = ""
  file_permission = "0444"
}

resource "local_file" "domain_name" {
  filename = "code-server-${digitalocean_droplet.codeserver.ipv4_address}.nip.io"
  content = ""
  file_permission = "0444"
}

resource "local_file" "inventory" {
  filename = "inventory.yaml"
  content = templatefile("template.yaml.tftpl", {
    private_ssh_key = var.ssh_private_key,
    codeserver = digitalocean_droplet.codeserver.name,
    codeserver_ip = digitalocean_droplet.codeserver.ipv4_address,
    codeserver_domain = local_file.domain_name.filename,
    codeserver_password = var.codeserver-password,
  })
  file_permission = "0444"
}
