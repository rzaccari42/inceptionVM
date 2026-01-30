ARG ALPINE_V=3.22

FROM alpine:${ALPINE_V}

RUN apk update
RUN apk add --no-cache \
	bash \
	su-exec \
	curl \
	tar \
	mariadb-client \
	php82 \
	php82-fpm \
	php82-mysqli \
	php82-json \
	php82-curl \
	php82-mbstring \
	php82-xml \
	php82-gd \
	php82-zip \
	php82-phar \
	php82-opcache

RUN ln -sf /usr/bin/php82 /usr/bin/php

RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php82/php-fpm.d/www.conf && \
	sed -i 's|^;daemonize = yes|daemonize = no|' /etc/php82/php-fpm.conf

RUN adduser -D -H -s /sbin/nologin www

RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

WORKDIR /var/www/html

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm82", "-F"]
