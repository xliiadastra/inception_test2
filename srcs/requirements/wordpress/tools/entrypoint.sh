#!/bin/sh
db_name=`wp config get DB_NAME 2> /dev/null`
wp_admin=`wp user get admin --field=user_login 2> /dev/null`
wp_user=`wp user get ${WP_USER} --field=user_login 2> /dev/null`


if [ ! -f "/var/www/html/index.php" ]; then
	wp core download --locale=ko_KR --path=/var/www/html --force
fi

if [ "$db_name" = "" ]; then
	wp config create --dbhost=mariadb:3306 --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_USER_PASSWORD}
fi

if [ "$wp_admin" = "" ] || [ "$wp_admin" = 'admin' ]; then
	wp core install --admin_user=${WP_ADMIN} --admin_email=${WP_ADMIN_EMAIL} --admin_password=${WP_ADMIN_PASSWORD} --url=http://donghyuk.42.fr --title='inception'
fi

if [ "$wp_user" = "" ]; then
	wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=${WP_USER_ROLE}
fi

# Run php-fpm
php-fpm --nodaemonize
