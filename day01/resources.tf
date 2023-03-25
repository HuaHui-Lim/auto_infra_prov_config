data "digitalocean_ssh_key" "aipc" {
  name = "MacSSH" //name of ssh-key in digital ocean
}

output "aipc_fingerprint" {
  description = "AIPC (Optional Variable)"
  #data.<resource type>.<resource name>.<function?>
  value = data.digitalocean_ssh_key.aipc.fingerprint 
}

output "aipc_public_key" {
  value = data.digitalocean_ssh_key.aipc.public_key
}

# pull image
# docker pull <image>
resource "docker_image" "dov-bear" {
  name = "chukmunnlee/dov-bear:v4"
}

# run container
# docker run -d -p 8080:3000 <image>
resource "docker_container" "dov-bear" {
  name = "my-dov-bear" #container name

  # for resources don't need resources.<resource type>.<resource name>
  image = docker_image.dov-bear.image_id

  ports {
    # docker's image port
    internal = 3000

    # external port to bind to
    external = 3000
  }

  env = [
    "INSTANCE_NAME=my-dov-bear"
  ]
}
