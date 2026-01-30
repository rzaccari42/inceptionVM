ARG ALPINE_V=3.22

FROM alpine:${ALPINE_V}

ENV DOMAIN_NAME="razaccar.42.fr"

RUN apk update
RUN apk add --no-cache \
	nginx \
	openssl \
	bash \
	sudo \
	ca-certificates

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /run/nginx /var/cache/nginx /var/www/html && \
	chown -R nginx:nginx /var/cache/nginx /var/www/html

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

