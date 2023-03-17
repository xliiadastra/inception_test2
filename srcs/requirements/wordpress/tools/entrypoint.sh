#!/bin/sh
# DB_NAME call
db_name=`wp config get DB_NAME 2> /dev/null`
# admin ID call
wp_admin=`wp user get admin --field=user_login 2> /dev/null`
# wp_user ID call
wp_user=`wp user get ${WP_USER} --field=user_login 2> /dev/null`

# index.php install
if [ ! -f "/var/www/html/index.php" ]; then
	wp core download --locale=ko_KR --path=/var/www/html --force
fi
# db install
if [ "$db_name" = "" ]; then
	wp config create --dbhost=mariadb:3306 --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_USER_PASSWORD}
fi
# wp root install
if [ "$wp_admin" = "" ] || [ "$wp_admin" = 'admin' ]; then
	wp core install --admin_user=${WP_ADMIN} --admin_email=${WP_ADMIN_EMAIL} --admin_password=${WP_ADMIN_PASSWORD} --url=http://yichoi.42.fr --title='inception'
fi
# wp user install
if [ "$wp_user" = "" ]; then
	wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=${WP_USER_ROLE}
fi

# Run php-fpm
php-fpm --nodaemonize

# foreground 로 실행 시키기 위해 php-fpm --nodemonize 한다.
# 도커 컨테이너를 background로 실행시키는 경우, 컨테이너가 시작되고 바로 종료되는 경우가 있다. 주로 컨테이너 내에서 실행되는 프로세스가 백그라운드로 실행될 때 발생한다. 백그라운드 프로세스는 데몬으로 실행되기 때문에 프로세스가 실행 중인 동안에도 컨테이너가 종료될 수 있다. 그러나 foreground는 프로세스가 실행 중인 동안에는 컨테이너가 종료되지 않는다. 따라서 nginx 같은 웹 서버와 같이 실행되어야 하는 프로세스들은 foreground 로 실행시킨다.
