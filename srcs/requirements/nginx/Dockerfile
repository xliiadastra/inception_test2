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

# req : 자체 서명된 x509 인증서와 개인키 생성
# x509 : CSR(인증서 서명 요청)이 아닌 자체 서명 인증서임을 지정, 인증서의 형식중 하나로 사용되는 표준 규격.
# days 365 : 유효기간 지정
# nodes : 개인 키를 암호로 암호화하지 않도록 지정
# newkey rsa:2048 : 크기가 2048 비트인 새 RSA 키 쌍을 생성
# keyout : 개인 key 저장경로
# out : 공개 키 저장경로
# subj : 국가, 주, 지역, 조직, 조직단위, 이메일, 주소
