#!/bin/bash

if [ -z "$MAIN_DOMAIN" ]; then
    echo "Cannot retrieve clear_url."
    exit 1
fi


echo "$PASSWORD" | sudo -S mkdir -p /etc/systemd/resolved.conf.d

echo -e "[Resolve]\nDNS=127.0.0.1\nDomains=~$MAIN_DOMAIN\n" \
  | tee $HOME_DIR/warden.conf > /dev/null

echo "$PASSWORD" | sudo -S cp $HOME_DIR/warden.conf /etc/systemd/resolved.conf.d/warden.conf

echo "$PASSWORD" | sudo -S systemctl restart systemd-resolved

