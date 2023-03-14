#!/bin/sh

# mysql이 소켓파일을 저장하는 디렉토리
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

# mysql 데이터베이스 사용.
# 권한 변경 내용 반영을 위해 캐시 지움.
# $MYSQL_DATABASE 이름의 데이ㅂ터베이스를 생성. 문자셋 'utf8'
# root 에게 모든 권한 부여. 단, localhost 접근시에만 유효.
# $MYSQL_DATABASE 에 해당하는 데이터베이스에 대해 $MYSQL_USER 사용자에게 모든 권한 부여.
