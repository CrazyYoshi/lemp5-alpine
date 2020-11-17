FROM alpine:3.8
RUN apk --no-cache update && apk --no-cache upgrade
RUN apk add --no-cache nginx \
    mariadb \
    mariadb-common \ 
    mariadb-client\ 
    php5-fpm \
    php5-opcache  \
    php5-xml \
    php5-ctype \
    php5-gd  \
    php5-mysql \
    php5-mysqli \
    php5-pdo \
    php5-pdo_mysql \
    php5-curl \
    php5-common \
    php5-json \
    php5-mcrypt 

COPY run.sh /usr/sbin/run.sh
COPY php.ini /etc/php5/php.ini
COPY php-fpm.conf /etc/php5/php-fpm.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.php /usr/share/nginx/html/index.php

RUN chmod +x /usr/sbin/run.sh \
    && mkdir -p /usr/src/sqldump

VOLUME /usr/src/sqldump
VOLUME /etc/nginx
VOLUME /usr/share/nginx/html

EXPOSE 80

ENTRYPOINT ["/usr/sbin/run.sh"]