#!/bin/bash


file_path="$MAGENTO_CONTENT_PATH/.env"

clear_url=$MAIN_DOMAIN;
cp -v "$(pwd)/magento/.warden/.env" $file_path

echo $file_path
# Str for modifying
site1="clear\.magento2\.loc"

# If file exist
if [ -f "$file_path" ]; then
    # Modifying the file
    sed -i "s|$site1|$MAIN_DOMAIN|" "$file_path"
    echo "Modifying complete(.env)."
else
    echo "File $file_path not found."
    exit 1
fi

FILE_PATH="$HOME/.warden/warden-env.yml"
TLS_DECLARATION='      - "traefik.http.routers.${WARDEN_ENV_NAME}-nginx.tls=false"'

if [[ -f "$FILE_PATH" ]]; then
    sed -i 's/      - "traefik.http.routers.${WARDEN_ENV_NAME}-nginx.tls=true"/'"$TLS_DECLARATION"'/' "$FILE_PATH"
    echo "Changes successfully applied."
else
    echo "File not found: $FILE_PATH"
fi

FILE_PATH="$HOME/.warden/warden-env.yml"
TLS_DECLARATION='      - "traefik.http.routers.${WARDEN_ENV_NAME}-phpmyadmin.tls=false"'

if [[ -f "$FILE_PATH" ]]; then
    sed -i 's/      - "traefik.http.routers.${WARDEN_ENV_NAME}-phpmyadmin.tls=true"/'"$TLS_DECLARATION"'/' "$FILE_PATH"
    echo "Changes successfully applied."
else
    echo "File not found: $FILE_PATH"
fi
