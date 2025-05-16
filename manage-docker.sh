#!/bin/bash

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do echo $PASSWORD | sudo -S sshpass apt-get remove $pkg; done


# Add Docker's official GPG key:
echo $PASSWORD | sudo -S sshpass apt-get update
echo $PASSWORD | sudo -S sshpass apt-get install ca-certificates curl
echo $PASSWORD | sudo -S sshpass install -m 0755 -d /etc/apt/keyrings
echo $PASSWORD | sudo -S sshpass curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo $PASSWORD | sudo -S sshpass chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee $HOME/docker.list > /dev/null
echo $PASSWORD | sudo -S sshpass mv $HOME/docker.list /etc/apt/sources.list.d/docker.list
echo $PASSWORD | sudo -S sshpass apt-get update


echo $PASSWORD | sudo -S sshpass apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


echo $PASSWORD | sudo -S sshpass usermod -aG docker $USER;

newgrp docker;

echo $PASSWORD | sudo -S sshpass systemctl start docker.service
echo $PASSWORD | sudo -S sshpass systemctl start containerd.service

docker run hello-world;

echo $PASSWORD | sudo -S sshpass systemctl enable docker.service
echo $PASSWORD | sudo -S sshpass systemctl enable containerd.service
