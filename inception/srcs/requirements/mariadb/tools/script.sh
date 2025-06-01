#!/bin/bash
service mysql start 

sed -i 's/127.0.0.1/0.0.0.0/'  /etc/mysql/mariadb.conf.d/50-server.cnf

echo "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;
        CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
        GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';
        FLUSH PRIVILEGES;" > database.sql;

mysql < database.sql
killall mysqld
mysqld
