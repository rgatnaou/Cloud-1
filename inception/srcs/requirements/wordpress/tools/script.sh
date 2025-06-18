#!/bin/bash
set -e

WWW_DIR=/var/www/html
FLAG_FILE="$WWW_DIR/.wordpress_installed"

mkdir -p "$WWW_DIR"
cd "$WWW_DIR"

# Only download and extract WordPress if not already done
if [ ! -f "$FLAG_FILE" ]; then
    echo "Downloading and extracting WordPress..."
    wget -q https://wordpress.org/latest.tar.gz
    tar xzf latest.tar.gz
    mv -f wordpress/* .
    rm -rf latest.tar.gz wordpress

    # Setup wp-config.php if it doesn't exist
    if [ ! -f wp-config.php ]; then
        echo "* Creating wp-config.php..."
        cp wp-config-sample.php wp-config.php

        sed -i -r "s/database_name_here/$MARIADB_DATABASE/" wp-config.php
        sed -i -r "s/username_here/$MARIADB_USER/" wp-config.php
        sed -i -r "s/password_here/$MARIADB_PASSWORD/" wp-config.php
        sed -i -r "s/localhost/mariadb/" wp-config.php
    fi

    touch "$FLAG_FILE"
else
    echo "WordPress already installed, skipping setup."
fi

# Ensure wp-cli is installed (download if missing)
if ! command -v wp >/dev/null 2>&1; then
    echo "* Downloading wp-cli..."
    wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Wait for MariaDB to accept connections with correct credentials
echo "Waiting for MariaDB to be ready..."
until mysql -h mariadb -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" -e "SELECT 1" &>/dev/null; do
    echo "MariaDB is unavailable - sleeping"
    sleep 6
done
echo "MariaDB is up!"



# Configure WordPress via wp-cli if not installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install --url="$DOMAIN_NAME" \
                    --title="$WP_TITLE" \
                    --admin_user="$WP_ADMIN_USER" \
                    --admin_password="$WP_ADMIN_PASS" \
                    --admin_email="$WP_ADMIN_EMAIL" \
                    --skip-email \
                    --allow-root
else
    echo "WordPress is already installed."
fi

# Create additional user if it doesn't exist
if ! wp user get "$WP_USER" --allow-root >/dev/null 2>&1; then
    echo "Creating additional WordPress user: $WP_USER"
    wp user create "$WP_USER" "$WP_EMAIL" --role=author --user_pass="$WP_PASS" --allow-root
else
    echo "User $WP_USER already exists."
fi

# Change PHP-FPM listen port if not already changed
PHP_FPM_CONF="/etc/php/7.3/fpm/pool.d/www.conf"
if ! grep -q "listen = 9000" "$PHP_FPM_CONF"; then
    sed -i 's|listen = /run/php/php7.3-fpm.sock|listen = 9000|g' "$PHP_FPM_CONF"
fi

mkdir -p /run/php

# Run PHP-FPM in foreground
exec /usr/sbin/php-fpm7.3 -F
