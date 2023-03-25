#!/bin/sh
docker-machine create \
    --driver=generic \
    --generic-ssh-user=root \
    --generic-ip-address=<ip> \
    --generic-ssh-key=<private key> \
    name
