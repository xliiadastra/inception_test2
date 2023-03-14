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
RUN ln -s /usr/sbin/php-fpm81 /usr/sbin/php-fpm
RUN sed -i 's/;chdir = \/var\/www/chdir = \/var\/www\/html/g' /etc/php81/php-fpm.d/www.conf
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php81/php-fpm.d/www.conf

# wp-cli
WORKDIR /tmp
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin
RUN chmod +x /usr/local/bin/wp-cli.phar
RUN ln -sf /usr/local/bin/wp-cli.phar /usr/local/bin/wp

# wordpress
WORKDIR /var/www/html

# scripts
ADD tools/entrypoint.sh /scripts/entrypoint.sh
RUN chmod -R 755 /scripts

ENTRYPOINT ["/scripts/entrypoint.sh"]
