FROM  debian:buster

RUN apt-get update && \
    apt-get install -y php-curl php-fpm php-mysql wget unzip curl less mariadb-client  default-mysql-client && \
    apt-get clean


COPY tools/script.sh /
#COPY tools/wp-config.php  /var/www/html/wp-config.php

RUN chmod 777 /script.sh
# RUN chmod 777 /var/www/html/wp-config.php


EXPOSE 9000

CMD [ "/script.sh" ]