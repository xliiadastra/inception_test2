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
DELETE FROM mysql.user WHERE user='';
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

# /dev/null 은 unix 임시 파일이다. 보통 불필요한 출력을 제거할 때 사용된다.
# mysql 데이터베이스 사용.
# 권한 변경 내용 반영을 위해 캐시 지움.
# $MYSQL_DATABASE 이름의 데이터베이스를 생성. 문자셋 'utf8', 'utf8_general_ci'는 SQL 쿼리에서 대소문자를 구분하지 않게 해준다.
# root 에게 모든 권한 부여. 단, localhost 접근시에만 유효. (creat root).
# $MYSQL_DATABASE 에 해당하는 데이터베이스에 대해 $MYSQL_USER 사용자에게 모든 권한 부여. (creat user).
# bootstrap mode : 초기화, 설정 파일 적용, 데이터베이스 생성, 사용ㅅ자 생성, 권한 등을 부여. 이 초기화 과정을 통해 mysql 서버를 실행하기 전에 미리 데이터베이스를 생성하고 초기화할 수 있다.
# exec : mysql을 PID 1으로 주기 위해.
# $@ : 현재 프로세스를 대체하여 새로운 프로세스로 대체. 새로운 쉘을 실행시키지 않는다. 이 뜻은 exec 명령어가 현재 쉘 프로세스를 종료시키지 않고, 새로운 프로그램을 현재 쉘 프로세스에서 실행하게끔 하는 것이라고 말할 수 있다.
