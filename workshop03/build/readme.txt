create variables.pkrvars.hcl and add
    digitalocean_token = "???"

packer init
packer build -var-file=variables.pkrvars.hcl .