#!/usr/bin/env bash
set -euo pipefail

: "${MARIADB_DATABASE_NAME:?Must set MARIADB_DATABASE}"
: "${MARIADB_ROOT_PASSWORD_FILE:?Must set MARIADB_ROOT_PASSWORD}"
: "${MARIADB_USER:?Must set MARIADB_USER}"
: "${MARIADB_PASSWORD_FILE:?Must set MARIADB_PASSWORD}"

MARIADB_PASSWORD="$(cat "${MARIADB_PASSWORD_FILE}")"
MARIADB_ROOT_PASSWORD="$(cat "${MARIADB_ROOT_PASSWORD_FILE}")"
DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"

chown -R mysql:mysql /var/lib/mysql

run_sql() {
	mariadb --protocol=socket --socket="$SOCKET" \
		-uroot -p"${MARIADB_ROOT_PASSWORD}" -e "$1"
}

mysql_init_db() {
	echo "Initializing MariaDB data directory..."
	mariadb-install-db --user=mysql --ldata="${DATADIR}" > /dev/null

	echo "Starting temporary MariaDB server..."
	mariadbd --datadir="${DATADIR}" --user=mysql --skip-networking &
	pid="$!"

	for i in {30..0}; do
		if mariadb -uroot --protocol=socket -e "SELECT 1;" &> /dev/null; then
			break;
		fi
		echo "Waiting..."
		sleep 1
	done
	if [ "$i" = 0 ]; then
		echo "MariaDB init failed."
		exit 1
	fi

	echo "Configuring root user, database and app user..."
	run_sql "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';"
	run_sql "CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE_NAME}\`;"
	run_sql "CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
	run_sql "GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE_NAME}\`.* TO '${MARIADB_USER}'@'%';"
	run_sql "FLUSH PRIVILEGES;"

	echo "Database successfully initialized. Shutting down temporary server..."
	mariadb-admin -uroot -p"${MARIADB_ROOT_PASSWORD}" shutdown || kill "$pid"
}

if [ ! -d "${DATADIR}/mysql" ]; then
	mysql_init_db
else
 	echo "MariaDB database already initialized"
fi


echo "Starting MariaDB server..."
exec "$@"


