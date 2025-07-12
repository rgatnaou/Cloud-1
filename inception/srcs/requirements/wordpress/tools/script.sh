#!/bin/bash
set -e

WWW_DIR=/var/www/html
cd "$WWW_DIR"

export HTTP_HOST=$DOMAIN_NAME

# Install wp-cli if missing
if ! command -v wp >/dev/null 2>&1; then
    echo "Downloading wp-cli..."
    wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Download WordPress core if missing
if [ ! -f wp-login.php ]; then
    echo "Downloading WordPress core files..."
    wp core download --allow-root
fi

# Setup wp-config.php if missing
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/$MARIADB_DATABASE/" wp-config.php
    sed -i "s/username_here/$MARIADB_USER/" wp-config.php
    sed -i "s/password_here/$MARIADB_PASSWORD/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
fi

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
until mariadb -h mariadb -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" --ssl=0 -e "SELECT 1" &>/dev/null; do
  echo "MariaDB not ready, retrying in 5s..."
  sleep 5
done
echo "MariaDB is up!"

# Install WordPress if not installed
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
    echo "WordPress already installed."
fi

# Create additional user if missing
if ! wp user get "$WP_USER" --allow-root &>/dev/null; then
    echo "Creating user $WP_USER..."
    wp user create "$WP_USER" "$WP_EMAIL" --role=author --user_pass="$WP_PASS" --allow-root
else
    echo "User $WP_USER exists."
fi

# Start PHP-FPM
exec php-fpm
