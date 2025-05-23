#!/bin/bash

echo $MAGENTO_CONTENT_PATH

FILE_PATH_ENV="$MAGENTO_CONTENT_PATH/.env"
echo ".env file path" $FILE_PATH_ENV

mkdir -p "$MAGENTO_DOT_WARDEN_CONTENT_PATH"
FILE_PATH_WARDEN_ENV_YML="$MAGENTO_CONTENT_PATH/.warden/warden-env.yml"


cp -v "$(pwd)/magento/.warden/.env" "$FILE_PATH_ENV"
cp -v "$(pwd)/magento/.warden/warden-env.yml" "$FILE_PATH_WARDEN_ENV_YML"

echo "$FILE_PATH_ENV"
echo "$FILE_PATH_WARDEN_ENV_YML"
site1="clear\.magento2\.loc"

if [ -f "$FILE_PATH_ENV" ]; then
    sed -i "s|$site1|$MAIN_DOMAIN|" "$FILE_PATH_ENV"
    echo "Modifying complete(.env)."
else
    echo "File $FILE_PATH_ENV not found."
    exit 1
fi


echo "warden-env.yml file path" $FILE_PATH_WARDEN_ENV_YML
TLS_DECLARATION_NGINX='      - "traefik.http.routers.${WARDEN_ENV_NAME}-nginx.tls=false"'

if [[ -f "$FILE_PATH_WARDEN_ENV_YML" ]]; then
    sed -i 's/      - "traefik.http.routers.${WARDEN_ENV_NAME}-nginx.tls=true"/'"$TLS_DECLARATION_NGINX"'/' "$FILE_PATH_WARDEN_ENV_YML"
    echo "Changes successfully applied."
else
    echo "File not found: $FILE_PATH_WARDEN_ENV_YML"
fi


TLS_DECLARATION_PMA='      - "traefik.http.routers.${WARDEN_ENV_NAME}-phpmyadmin.tls=false"'

if [[ -f "$FILE_PATH_WARDEN_ENV_YML" ]]; then
    sed -i 's/      - "traefik.http.routers.${WARDEN_ENV_NAME}-phpmyadmin.tls=true"/'"$TLS_DECLARATION_PMA"'/' "$FILE_PATH_WARDEN_ENV_YML"
    echo "Changes successfully applied."
else
    echo "File not found: $FILE_PATH_WARDEN_ENV_YML"
fi
