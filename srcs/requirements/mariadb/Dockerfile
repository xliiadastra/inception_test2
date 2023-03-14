FROM alpine:3.17.2

ENV MARIADB_VER="10.6.12-r0"

# apk install
RUN apk update
RUN apk add --no-cache mariadb=${MARIADB_VER}

# mariadb
RUN sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
RUN sed -i 's/#bind-address=0.0.0.0/bind-address=0.0.0.0/g' /etc/my.cnf.d/mariadb-server.cnf

# script
COPY tools/entrypoint.sh /scripts/entrypoint.sh
RUN chmod -R 755 /scripts

ENTRYPOINT ["/scripts/entrypoint.sh"]
