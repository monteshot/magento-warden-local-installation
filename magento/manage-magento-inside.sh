#!/bin/bash

echo "Fixing permissions..."
sudo chown -R www-data:www-data /var/www/html

echo "Installing Magento App..."
bin/magento setup:install -vvv \
    --backend-frontname=admin \
    --cleanup-database \
    --db-host=db \
    --db-name=magento \
    --db-user=magento \
    --db-password=magento \
    --search-engine=opensearch \
    --opensearch-host=opensearch \
    --opensearch-port=9200 \
    --opensearch-index-prefix=magento2 \
    --opensearch-enable-auth=0 \
    --opensearch-username=admin \
    --opensearch-password=admin \
    --opensearch-timeout=15 \
    --session-save=redis \
    --session-save-redis-host=redis \
    --session-save-redis-port=6379 \
    --session-save-redis-db=2 \
    --session-save-redis-max-concurrency=20 \
    --cache-backend=redis \
    --cache-backend-redis-server=redis \
    --cache-backend-redis-db=0 \
    --cache-backend-redis-port=6379 \
    --page-cache=redis \
    --page-cache-redis-server=redis \
    --page-cache-redis-db=1 \
    --page-cache-redis-port=6379

bin/magento mo:d Magento_TwoFactorAuth Magento_AdminAdobeImsTwoFactorAuth
bin/magento config:set --scope=store --scope-code=default --lock-env web/unsecure/base_url \
    "https://${main_domain}/"

bin/magento config:set --scope=store --scope-code=default --lock-env web/secure/base_url \
    "https://${main_domain}/"

bin/magento config:set --scope=store --scope-code=admin --lock-env web/unsecure/base_url \
    "https://${main_domain}/"

bin/magento config:set --scope=store --scope-code=admin --lock-env web/secure/base_url \
    "https://${main_domain}/"


bin/magento config:set --lock-env web/secure/offloader_header X-Forwarded-Proto

bin/magento config:set --lock-env web/secure/use_in_frontend 1
bin/magento config:set --lock-env web/secure/use_in_adminhtml 1
bin/magento config:set --lock-env web/seo/use_rewrites 1

bin/magento config:set --lock-env system/full_page_cache/caching_application 1
bin/magento config:set --lock-env system/full_page_cache/ttl 604800

bin/magento config:set --lock-env catalog/search/enable_eav_indexer 1

bin/magento config:set --lock-env dev/static/sign 1
bin/magento d:m:se developer

echo "Processing Indexer settings..."

ENV_FILE="app/etc/env.php"
INDEXER_FILE="app/etc/indexer.php"
TEMP_FILE="app/etc/temp_env.php"

php -r "
\$env = include '$ENV_FILE';
\$indexer = include '$INDEXER_FILE';
\$env = array_merge_recursive(\$env, \$indexer);
file_put_contents('$TEMP_FILE', '<?php return ' . var_export(\$env, true) . ';');
"
mv $TEMP_FILE $ENV_FILE

bin/magento indexer:reindex
bin/magento cache:flush

bin/magento admin:user:create --admin-user='monteshot' --admin-password='M0nteshot' --admin-email='faqreg@gmail.com' --admin-firstname='MonteShot' --admin-lastname='Dev'

bin/magento setup:perf:generate-fixtures /var/www/html/setup/performance-toolkit/profiles/ce/small.xml

bin/magento config:set --scope=store --scope-code=admin --lock-env web/unsecure/base_url \
    "https://${main_domain}/"

bin/magento config:set --scope=store --scope-code=admin --lock-env web/secure/base_url \
    "https://${main_domain}/"

bin/magento cache:flush

#bin/magento d:m:se production
bin/magento cache:flush
bin/magento cron:install
bin/magento cron:run

echo "Fixing permissions..."
sudo chown -R www-data:www-data /var/www/html

echo "Magento App installed"
