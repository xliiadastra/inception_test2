FROM alpine:3.17.2

ENV MARIADB_VER="10.6.12-r0"

# apk install
RUN apk update
RUN apk add --no-cache mariadb=${MARIADB_VER} mariadb-client

# mariadb
RUN sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
RUN sed -i 's/#bind-address=0.0.0.0/bind-address=0.0.0.0/g' /etc/my.cnf.d/mariadb-server.cnf

# script
COPY tools/entrypoint.sh /scripts/entrypoint.sh
RUN chmod -R 755 /scripts

ENTRYPOINT ["/scripts/entrypoint.sh"]

# skip-networking 을 주석처리 해주어야 다른 컨테이너들과 통신시킬 수 있다.
# bind-address mariadb/mysql 서버가 연결 요청을 수신하는 ip 주소를 설정하는 옵션이며 0.0.0.0으로 설정되어있기에 모든 인터페이스에서 요청을 수신할 수 있다.
