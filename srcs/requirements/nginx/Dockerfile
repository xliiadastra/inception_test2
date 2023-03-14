FROM alpine:3.17.2

# apk install
ENV NGINX_VER="1.22.1-r0"

RUN apk update
RUN apk add nginx=${NGINX_VER} openssl

# nginx
COPY conf/default.conf /etc/nginx/http.d
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# nginx:ssl
RUN openssl req \
        -x509 \
        -days 365 \
        -nodes \
        -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx.key \
        -out /etc/ssl/certs/nginx.crt \
        -subj "/C=KR/ST=Seoul/L=Gaepo/O=42Seoul/OU=Dev/emailAddress=yichoi@student.seoul42.kr/CN=www.yichoi.42.fr"

# port
EXPOSE 443

ENTRYPOINT [ "nginx" ]
