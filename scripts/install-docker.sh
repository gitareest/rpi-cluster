#!/bin/bash

# https://docs.docker.com/install/linux/docker-ce/debian/

apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo "deb [arch=armhf] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
echo '{ "insecure-registries":["pi-1:5000"] }' > /etc/docker/daemon.json
service docker restart