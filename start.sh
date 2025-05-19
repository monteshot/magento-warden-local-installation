#!/bin/bash


if [[ -z "$PASSWORD" ]]; then
    echo "PASSWORD variable is not set. Please set it before running the script."
    exit 1
fi

HOME_DIR="/home/$(logname)"
MAGENTO_PATH=$HOME_DIR/$MAIN_DOMAIN
MAGENTO_CONTENT_PATH=$HOME_DIR/$MAIN_DOMAIN'/content'
MAGENTO_DOT_WARDEN_CONTENT_PATH=$MAGENTO_CONTENT_PATH'/.warden'
MAIN_SCRIPT_DIR=$(pwd)

mkdir -p $MAGENTO_CONTENT_PATH
mkdir -p $MAGENTO_DOT_WARDEN_CONTENT_PATH
WARDEN_BREW_DIR=$(brew --prefix warden)

export PASSWORD
export HOME_DIR
export MAGENTO_PATH
export MAGENTO_CONTENT_PATH
export WARDEN_BREW_DIR
export MAIN_SCRIPT_DIR
export MAGENTO_DOT_WARDEN_CONTENT_PATH

echo "HOME_DIR: $HOME_DIR"
echo "MAGENTO_PATH: $MAGENTO_PATH"
echo "MAGENTO_CONTENT_PATH: $MAGENTO_CONTENT_PATH"
echo "WARDEN_BREW_DIR: $WARDEN_BREW_DIR"
echo "MAIN_SCRIPT_DIR: $MAIN_SCRIPT_DIR"
echo "MAGENTO_DOT_WARDEN_CONTENT_PATH: $MAGENTO_DOT_WARDEN_CONTENT_PATH"

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

echo "Setup Complete"
