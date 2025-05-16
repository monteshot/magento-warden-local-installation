#!/bin/bash


if [[ -z "$PASSWORD" ]]; then
    echo "PASSWORD variable is not set. Please set it before running the script."
    exit 1
fi

HOME_DIR="/home/$(logname)"

MAGENTO_PATH=$HOME_DIR/$MAIN_DOMAIN
MAGENTO_CONTENT_PATH=$HOME_DIR/$MAIN_DOMAIN/'content'

mkdir -p $MAGENTO_CONTENT_PATH
WARDEN_BREW_DIR=$(brew --prefix warden)

echo "$PASSWORD" | sudo -S apt install sshpass -y

echo "Managing Docker"
/bin/bash -c "./manage-docker.sh"

echo "Managing Brew"
/bin/bash -c "./manage-brew.sh"

echo "Managing Warden"

/bin/bash -c "./manage-warden.sh"

echo "Managing Traefik"

/bin/bash -c "./manage-traefik.sh"

echo "Managing Magento"

/bin/bash -c "./manage-magento.sh"

echo "Managing Post-Setup"

/bin/bash -c "./manage-post-setup.sh"

echo "Setup Complete"
