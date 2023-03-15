FROM alpine:3.17.2

ENV PHP81_FPM_VER="8.1.16-r0"

RUN apk update

# apk install
RUN apk add curl	php81-fpm=${PHP81_FPM_VER} \
					php81=${PHP81_FPM_VER} \
					php81-mysqli=${PHP81_FPM_VER} \
					php81-phar=${PHP81_FPM_VER} \
					php81-iconv=${PHP81_FPM_VER} \
					mysql-client

# php-fpm
# php81 version 을 php 명령어를 사용할 때마다 실행시킬 수 있도록 링크.
RUN ln -s /usr/sbin/php-fpm81 /usr/sbin/php-fpm
# chidr을 html로 바꿔줘야 wordpress 가 경로를 읽을 수 있다.
RUN sed -i 's/;chdir = \/var\/www/chdir = \/var\/www\/html/g' /etc/php81/php-fpm.d/www.conf
# localhost 뿐만 아닌 다른 호스트에서도 요청 받을 수 있게 변경.
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php81/php-fpm.d/www.conf

# wp-cli
WORKDIR /tmp
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# /usr/local/bin 위치는 시스템 전역에서 실행 가능한 바이너리 파일들이 위치하는 곳.
RUN mv wp-cli.phar /usr/local/bin
RUN chmod +x /usr/local/bin/wp-cli.phar
RUN ln -sf /usr/local/bin/wp-cli.phar /usr/local/bin/wp

# wordpress
WORKDIR /var/www/html

# scripts
ADD tools/entrypoint.sh /scripts/entrypoint.sh
RUN chmod -R 755 /scripts

ENTRYPOINT ["/scripts/entrypoint.sh"]

# fpm : FastCGI 서버로 실행시킬 수 잇다. 웹 서버와 함께 사용하여 php 코드를 처리하고 웹 페이지를 생성.
# php81 : php 언어 제공 및 사용
# mysqli : php에서 mysql 데이터베이스와 상호작용하기 위한 확장 라이브러리.
# phar : php 응용 프로그램을 패키징하고 배포하기 위한 포맷. php 애플리케이션을 phar 형식으로 패키징하고 실행할 수 있다. *phar(Php Archive) 형식 : 일반적으로 zip 파일과 같은 압축된 형태. php 인터프리터로 직접 실행할 수 있기 때문에 웹서버나 다른 실행 환경 없이도 바로 실행 가능.
# iconv : php에서 문자열 변환을 수행하는 확장 라이브러리. 설치하면 문자열을 변환하고 인코딩을 변경할 수 있다.
