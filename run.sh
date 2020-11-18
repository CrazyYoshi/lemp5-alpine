#!/bin/sh
echo '---- CREATING & LOADING SQL DUMPS / STARTING Mariadb ----'
if [ -d "/run/mysqld" ]; then
    chown -R mysql:mysql /run/mysqld
else
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi
if [ -d /var/lib/mysql/mysql ]; then
    chown -R mysql:mysql /var/lib/mysql
    /usr/bin/mysqld --user=mysql &
else
    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --user=mysql --ldata=/var/lib/mysql >/dev/null
    /usr/bin/mysqld --user=mysql &
    while ! nc -z localhost 3306; do
        sleep 1
    done
    /usr/bin/mysql --user=root -e \
        "UPDATE mysql.user SET plugin='mysql_native_password'; FLUSH PRIVILEGES"
    for i in /usr/src/sqldump/*.sql; do
        if [ -f "$i" ]; then
            echo "Loading sql dump : $i"
            /usr/bin/mysql <$i
        fi
    done
fi
while ! nc -z localhost 3306; do
    sleep 1
done
echo 'Mariadb available'
echo '---- START NGINX & PHP5-FPM ----'
pkill -f php-fpm
pkill -f nginx
php-fpm5 -D
nginx -g 'daemon off;'
