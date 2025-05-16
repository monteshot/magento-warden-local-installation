#!/bin/bash

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do echo "$PASSWORD" | sudo -S apt-get remove $pkg; done


# Add Docker's official GPG key:
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install ca-certificates curl
echo "$PASSWORD" | sudo -S install -m 0755 -d /etc/apt/keyrings
echo "$PASSWORD" | sudo -S curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "$PASSWORD" | sudo -S chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee $HOME_DIR/docker.list
echo "$PASSWORD" | sudo -S mv $HOME_DIR/docker.list /etc/apt/sources.list.d/docker.list
echo "$PASSWORD" | sudo -S apt-get update


echo "$PASSWORD" | sudo -S apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


echo "$PASSWORD" | sudo -S usermod -aG docker $USER;

newgrp docker << END
echo "Group docker activated"
END

echo "$PASSWORD" | sudo -S systemctl start docker.service
echo "$PASSWORD" | sudo -S systemctl start containerd.service

docker run hello-world;

echo "$PASSWORD" | sudo -S systemctl enable docker.service
echo "$PASSWORD" | sudo -S systemctl enable containerd.service
