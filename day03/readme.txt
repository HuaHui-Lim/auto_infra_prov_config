create variables.pkrvars.hcl and add digitalocean_token = "??"

packer init
packer build -var-file=variables.pkrvars.hcl .

create s3_backend.hcl

contents are
    access_key = "??"
    secret_key = "??"
    bucket = "??"

terraform init --backend-config ./s3_backend.hcl

create terraform.tfvars (for terraform) and add digitalocean_token = "??"

terragrunt