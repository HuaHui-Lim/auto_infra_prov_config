data "digitalocean_ssh_key" "aipc" {
  name = "MacSSH" //name of ssh-key in digital ocean
}

data "digitalocean_ssh_key" "host_key" {
  name = "fred_key" //name of ssh-key in digital ocean
}

#resource "digitalocean_ssh_key" "host_key" {
#  name = "fred_key_2"
#  public_key = file(var.ssh_public_key)
#}

resource "digitalocean_droplet" "workshop02" {
  image  = "ubuntu-20-04-x64"
  name   = "workshop02" 
  region = "sgp1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [ data.digitalocean_ssh_key.aipc.fingerprint, data.digitalocean_ssh_key.host_key.fingerprint ]
  connection {
    type = "ssh"
    user = "root"
    private_key = file(var.ssh_private_key)
    host = self.ipv4_address
  }
}

resource "local_file" "inventory-yaml" {
  filename = "inventory.yaml"
  content = templatefile("./templates/inventory.yaml.tftpl", {
    codeserver_root_user = "root"
    ssh_private_key = var.ssh_private_key
    codeserver_name = digitalocean_droplet.workshop02.name
    codeserver_ip = digitalocean_droplet.workshop02.ipv4_address
    codeserver_domain = digitalocean_droplet.workshop02.ipv4_address
    codeserver_password = "changeIt"
  })
}
