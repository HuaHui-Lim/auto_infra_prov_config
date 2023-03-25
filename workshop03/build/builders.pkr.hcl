source "digitalocean" "codeserver" {
  api_token = var.digitalocean_token
  image = var.digitalocean_image
  region = var.digitalocean_region
  size = var.digitalocean_size
  ssh_username = "root"
  snapshot_name = "codeserver"
}

build {
  sources = [
    "source.digitalocean.codeserver"
  ]

  provisioner "ansible" {
    playbook_file = "playbook.yaml"
    ansible_ssh_extra_args = [
        "-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
  }
}
