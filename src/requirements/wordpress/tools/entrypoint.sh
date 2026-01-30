#!/usr/bin/env bash
set -euo pipefail

WEB_ROOT="/var/www/html"
WP_ADMIN_PASSWORD="$(cat "${WP_ADMIN_PASSWORD_FILE}")"
WP_USER_PASSWORD="$(cat "${WP_USER_PASSWORD_FILE}")"
WP_DB_PASSWORD="$(cat "${WP_DB_PASSWORD_FILE}")"

echo $WP_DB_PASSWORD

chown -R www:www /var/www
chown -R www:www /var/log/php82

if [ -z "$(ls -A "$WEB_ROOT")" ]; then
	echo "WordPress volume is empti - installing core files..."
	tar -xzf /tmp/wordpress.tar.gz -C /tmp
	cp -R /tmp/wordpress/* "$WEB_ROOT"
	rm -rf /tmp/wordpress/
fi

if [ ! -f "$WEB_ROOT/wp-config.php" ]; then
	wp config create \
	  --dbname="$WP_DB_NAME" \
	  --dbuser="$WP_DB_USER" \
	  --dbpass="$WP_DB_PASSWORD" \
	  --dbhost="$WP_DB_HOST" \
	  --skip-check
fi

if ! wp core is-installed --path="$WEB_ROOT" --allow-root; then
	wp core install \
		--path="$WEB_ROOT" \
		--allow-root \
		--url="https://${DOMAIN_NAME}" \
		--title="inception" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}"

	wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
		--path="$WEB_ROOT" \
		--allow-root \
		--url="https://${DOMAIN_NAME}" \
		--role=author \
		--user_pass="${WP_USER_PASSWORD}"

	wp user list --allow-root --path="$WEB_ROOT"

fi

exec su-exec www:www "$@"
