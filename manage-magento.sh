#!/bin/bash

AUTH_JSON="$(cat "$MAIN_SCRIPT_DIR"/magento/auth.json)"

cd $MAGENTO_CONTENT_PATH

echo "$PASSWORD" | sudo -S rm -rf "$MAGENTO_CONTENT_PATH/*"

warden env exec php-fpm rm -rf /tmp/magento
warden env exec php-fpm mkdir -p /tmp/magento

warden env exec -e COMPOSER_AUTH="$AUTH_JSON" php-fpm composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=$MAGENTO_VERSION /tmp/magento -vvv

if [ $? -ne 0 ]; then
    echo "Failed to fetch Magento installation files. Please check the logs above."
    exit 1
fi

echo "Cleaning up old files..."
warden env exec php-fpm ls -la /var/www/html
warden env exec php-fpm sudo rm -rf /var/www/html/*
warden env exec php-fpm ls -la /var/www/html

echo "Moving new files..."
warden env exec php-fpm ls -la /tmp/magento
warden env exec php-fpm cp -ar /tmp/magento/* /var/www/html
warden env exec php-fpm ls -la /tmp/magento
echo "Copying new files to $MAGENTO_CONTENT_PATH..."
echo "$PASSWORD" | sudo -S cp -r "$MAIN_SCRIPT_DIR/magento/"* "$MAGENTO_CONTENT_PATH"

echo "Cleaning up temporary files..."
warden env exec php-fpm sudo rm -rf /tmp/magento

echo "Removing env.php ..."
warden env exec php-fpm rm ./app/etc/env.php || true;
echo "Removing config.php ..."
warden env exec php-fpm rm ./app/etc/config.php || true;
echo "Removing caches from new files ..."
warden env exec php-fpm rm -rf ./var/cache/* ./var/page_cache/* ./var/view_preprocessed/* ./generated/code/* ./pub/static/*;

echo "Starting Magento installation..."

warden env exec -e main_domain="$MAIN_DOMAIN" php-fpm /var/www/html/manage-magento-inside.sh
if [ $? -ne 0 ]; then
    echo "Magento installation failed. Please check the logs above."
    exit 1
fi
