# FROM  debian:buster
FROM  wordpress:php8.2-fpm-alpine

RUN apk update && \
    apk add --no-cache wget unzip curl less mariadb-client && \
    rm -rf /var/cache/apk/*


COPY tools/script.sh /
#COPY tools/wp-config.php  /var/www/html/wp-config.php

RUN echo "memory_limit = 500M" >> /usr/local/etc/php/conf.d/memory-limit.ini
RUN chmod 777 /script.sh
# RUN chmod 777 /var/www/html/wp-config.php


EXPOSE 9000

CMD [ "/script.sh" ]