#!/bin/sh

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

	tfile=`mktemp`
	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES ;
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD';
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

	/usr/bin/mysqld --user=mysql --bootstrap < $tfile
	rm -f $tfile
fi

exec /usr/bin/mysqld --user=mysql $@
