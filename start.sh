#!/bin/bash

PASSOWRD='M0nteShot'

sudo apt install sshpass -y

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do echo $PASSOWRD | sudo -S sshpass apt-get remove $pkg; done

curl -fsSL https://get.docker.com -o get-docker.sh
echo $PASSOWRD | sudo -S sshpass sh ./get-docker.sh

echo $PASSOWRD | sudo -S sshpass usermod -aG docker $USER;

newgrp docker;
docker run hello-world;


/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ;

echo >> /home/monteshot/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/monteshot/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo $PASSOWRD | sudo -S sshpass apt-get install build-essential -y
brew install gcc -q


brew install wardenenv/warden/warden -q;
warden svc up;

/bin/bash -c "./install-services.sh"
/bin/bash -c "./reinstall-local-small.sh"
