#!/bin/bash

clear_url=$MAIN_DOMAIN;


NONINTERACTIVE=1 brew install wardenenv/warden/warden -q;

echo "Creating Warden-related files(containers) under home directory"
warden svc up;


echo "$PASSWORD" | sudo -SE ./manage-warden-modification.sh

echo "Starting project containers"
cd $MAGENTO_CONTENT_PATH
warden env up

echo "Setting up Warden"
sed -i s/WARDEN_SERVICE_DOMAIN=$clear_url//g $HOME_DIR/.warden/.env
echo "WARDEN_SERVICE_DOMAIN=$clear_url" | tee -a $HOME_DIR/.warden/.env
sed -i s/TRAEFIK_LISTEN=127.0.0.1//g $HOME_DIR/.warden/.env
echo "TRAEFIK_LISTEN=0.0.0.0" | tee -a $HOME_DIR/.warden/.env
echo "$PASSWORD" | sudo -S ls -lah $HOME_DIR/.warden
echo "Restarting Warden to apply changes"
warden env down
warden env up

