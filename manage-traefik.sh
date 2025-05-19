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


# Path to docker-compose.yml
file_path=$WARDEN_BREW_DIR"/docker/docker-compose.yml"

# Marker of search
search_string="routers.traefik.rule"

# Final str for replace process
replace_string="      - traefik.http.routers.traefik.rule=Host(\`$MAIN_DOMAIN\`)"

# Str to commenting out
tls_line="- traefik.http.routers.traefik.tls=true"

# If file exist
if [ -f "$file_path" ]; then
    # Commenting the line with "tls=true"
    sed -i "s|$tls_line|\# $tls_line|g" "$file_path"

    # Modifying the file
     sed -i "s|.*$search_string.*|$replace_string|g" "$file_path"
    echo "File modified successfully(docker-compose.yml)."
else
    echo "File $file_path not found."
    exit 1
fi


# Path to traefik.yml
file_path=$WARDEN_BREW_DIR"/config/traefik/traefik.yml"

# Str for modifying
search_string="  http:"
redirection_string="      redirections:"
entry_point_string="        entryPoint:"
to_https_string="          to: https"
scheme_https_string="          scheme: https"

# If file exist
if [ -f "$file_path" ]; then
    # Modifying the file
    sed -i "s|  $search_string|#$search_string|" "$file_path"
    sed -i "s|$redirection_string|#$redirection_string|" "$file_path"
    sed -i "s|$entry_point_string|#$entry_point_string|" "$file_path"
    sed -i "s|$to_https_string|#$to_https_string|" "$file_path"
    sed -i "s|$scheme_https_string|#$scheme_https_string|" "$file_path"
    echo "Modifying complete(traefik.yml)."
else
    echo "File $file_path not found."
    exit 1
fi

