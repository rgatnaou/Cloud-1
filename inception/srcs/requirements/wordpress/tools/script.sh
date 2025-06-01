#!/bin/bash
mkdir -p /var/www/html
cd  /var/www/html/

wget https://wordpress.org/latest.tar.gz

tar xzvf latest.tar.gz

mv -f wordpress/* .


rm -rf latest.tar.gz wordpress

cp  wp-config-sample.php wp-config.php


sed -i -r "s/database_name_here/$MARIADB_DATABASE/1" wp-config.php
sed -i -r "s/username_here/$MARIADB_USER/1" wp-config.php
sed -i -r "s/password_here/$MARIADB_PASSWORD/1" wp-config.php
sed -i -r "s/localhost/mariadb/1" wp-config.php



#  configration wordpress

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h"mariadb" --silent; do
    echo "MariaDB is unavailable - sleeping"
    sleep 2
done
echo "MariaDB is up!"

# Configuration via wp-cli
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

# Only create user if it doesn't exist
if ! wp user get "$WP_USER" --allow-root >/dev/null 2>&1; then
    echo "Creating additional WordPress user: $WP_USER"
    wp user create "$WP_USER" "$WP_EMAIL" --role=author --user_pass="$WP_PASS" --allow-root
else
    echo "User $WP_USER already exists."
fi

# change port in php 
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf
mkdir /run/php

# run 
/usr/sbin/php-fpm7.3 -F