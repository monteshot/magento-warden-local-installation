#!/bin/bash

warden env exec php-fpm composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=$MAGENTO_VERSION /var/www/html/tmp/ -vvv

echo "$PASSWORD" | sudo -S rm -rf var/
mv $MAGENTO_CONTENT_PATH/tmp/* $MAGENTO_CONTENT_PATH/
rm -rf $MAGENTO_CONTENT_PATH/tmp/

warden env exec php-fpm rm ./app/etc/env.php;
warden env exec php-fpm rm ./app/etc/config.php;
warden env exec php-fpm rm -rf ./var/cache/* ./var/page_cache/* ./var/view_preprocessed/* ./generated/code/* ./pub/static/*;
main_domain=$MAIN_DOMAIN
cp ./magento $MAGENTO_CONTENT_PATH_PATH

warden env exec -e main_domain="$MAIN_DOMAIN" php-fpm manage-magento-inside.sh
