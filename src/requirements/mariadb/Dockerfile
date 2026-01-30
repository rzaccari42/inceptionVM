ARG ALPINE_V=3.22

FROM alpine:${ALPINE_V}

RUN apk update
RUN apk add --no-cache \
	bash \
	mariadb \
	mariadb-client

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["entrypoint.sh"]
CMD ["mariadbd", "--user=mysql", "--console"]
