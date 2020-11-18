FROM alpine:3.8
LABEL \
    Author='Miloud Maamar' \    
    Maintener='development@maamar.fr' \
    Licence='Mozilla Public License Version 2.0' \
    Version='1.0' \
    Description='Simple Lemp environment featuring unsecured MariaDb, Nginx, PHP5.6 (FPM). \
    Access to db should be done inside the container, otherwise extend this image to secure Mariadb.' \
    Usage='docker run -d -p [WWW_HOST_PORT]:80 -v [DB_HOST_ROOT]:/var/lib/mysql -v [DB_DUMPS_HOST_DIR]:/usr/src/sqldump \
    -v [WWW_HOST_ROOT]:/usr/share/nginx/html -v [WWW_HOST_VHOST]:/etc/nginx/sites-enabled/'

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