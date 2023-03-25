source "digitalocean" "mynginx" {
  api_token = var.digitalocean_token
  image = var.digitalocean_image
  region = var.digitalocean_region
  size = var.digitalocean_size
  ssh_username = "root"
  snapshot_name = "nginx"
}

build {
  sources = [
    "source.digitalocean.mynginx"
  ]

  provisioner "ansible" {
    playbook_file = "playbook.yaml"
    ansible_ssh_extra_args = [
        "-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
  }
}
