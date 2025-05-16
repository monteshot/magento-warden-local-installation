#!/bin/bash

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do echo $PASSWORD | sudo -S sshpass apt-get remove $pkg; done

curl -fsSL https://get.docker.com -o get-docker.sh || exit 0;
echo $PASSWORD | sudo -S sshpass sh ./get-docker.sh || exit 0;

echo $PASSWORD | sudo -S sshpass usermod -aG docker $USER;

newgrp docker;

echo $PASSWORD | sudo -S sshpass systemctl start docker.service
echo $PASSWORD | sudo -S sshpass systemctl start containerd.service

docker run hello-world;

echo $PASSWORD | sudo -S sshpass systemctl enable docker.service
echo $PASSWORD | sudo -S sshpass systemctl enable containerd.service
