#!/bin/bash

PASSOWRD='M0nteShot'
MAGENTO_PATH=$HOME/$MAIN_DOMAIN
MAGENTO_CONTENT_PATH=$HOME/$MAIN_DOMAIN/'content'
WARDEN_BREW_DIR=$(brew --prefix warden)


sudo apt install sshpass -y

/bin/bash -c "./manage-docker.sh"

/bin/bash -c "./manage-brew.sh"

/bin/bash -c "./manage-warden.sh"

/bin/bash -c "./manage-pre-setup.sh"

/bin/bash -c "./manage-traefik.sh"

/bin/bash -c "./manage-magento.sh"

/bin/bash -c "./manage-post-setup.sh"
