#!/bin/bash

AUTH_JSON="$(cat "$MAIN_SCRIPT_DIR"/magento/auth.json)"

cd $MAGENTO_CONTENT_PATH

echo "$PASSWORD" | sudo -S rm -rf "$MAGENTO_CONTENT_PATH/*"
warden env exec -e COMPOSER_AUTH="$AUTH_JSON" php-fpm composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=$MAGENTO_VERSION /var/www/html/tmp/ -vvv
echo "$PASSWORD" | sudo -S rm -rf var/
echo "$PASSWORD" | sudo -S mv "$MAGENTO_CONTENT_PATH"/tmp/* "$MAGENTO_CONTENT_PATH"/
echo "$PASSWORD" | sudo -S rm -rf "$MAGENTO_CONTENT_PATH"/tmp/

warden env exec php-fpm rm ./app/etc/env.php;
warden env exec php-fpm rm ./app/etc/config.php;
warden env exec php-fpm rm -rf ./var/cache/* ./var/page_cache/* ./var/view_preprocessed/* ./generated/code/* ./pub/static/*;

cp "$(pwd)/magento" "$MAGENTO_CONTENT_PATH"

warden env exec -e main_domain="$MAIN_DOMAIN" php-fpm manage-magento-inside.sh
