FROM  nginx:stable-alpine3.21-slim

RUN apk update && \
    apk add --no-cache nginx openssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/selfsigned.key -out /etc/ssl/certs/selfsigned.crt \
    -subj "/CN=rgatnaou/O=1337.ma/L=KHOURIBGA/C=MA"

COPY ./conf/nginx.conf /etc/nginx

EXPOSE	443