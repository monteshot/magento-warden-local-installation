#!/bin/bash

clear_url=$MAIN_DOMAIN;


# Path to env.php
file_path="$MAGENTO_CONTENT_PATH/app/etc/env.php"
echo $file_path
# Str for modifying
site1="clear\.magento2\.loc"

# If file exist
if [ -f "$file_path" ]; then

    sed -i "s|$site1|$clear_url|" "$file_path"
    echo "Modifying complete(env.php)."
    warden env exec php-fpm php bin/magento a:c:i
    warden env exec php-fpm php bin/magento mo:d Magento_TwoFactorAuth Magento_AdminAdobeImsTwoFactorAuth
    warden env exec php-fpm php bin/magento s:up
    warden env exec php-fpm php bin/magento cache:enable
    warden env exec php-fpm php bin/magento d:m:se developer
    warden env exec php-fpm php bin/magento setup:perf:generate-fixtures /var/www/html/setup/performance-toolkit/profiles/ce/small.xml
    warden env exec php-fpm php bin/magento cache:flush
    warden env exec php-fpm php bin/magento cron:install
    warden env exec php-fpm php bin/magento cron:run
else
    echo "File $file_path not found."
    exit 1
fi
