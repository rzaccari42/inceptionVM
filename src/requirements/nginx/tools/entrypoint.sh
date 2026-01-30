#!/usr/bin/env bash

set -euo pipefail

: "${DOMAIN_NAME:=localhost}"

CERT_DIR="/etc/nginx/ssl/certs"
KEY_DIR="/etc/nginx/ssl/private"
CRT="${CERT_DIR}/${DOMAIN_NAME}.crt"
KEY="${KEY_DIR}/${DOMAIN_NAME}.key"

mkdir -p "$CERT_DIR" "$KEY_DIR"
sudo chmod -R 600 /etc/nginx/ssl
if [ ! -f "${CRT}" ] || [ ! -f "${KEY}" ]; then
	echo "Generating self-signed certificate for ${DOMAIN_NAME}"
	openssl req -x509 -newkey rsa:2048 -noenc -days 365 \
	-keyout "${KEY}" -out "${CRT}" \
	-subj "/CN=${DOMAIN_NAME}" \
	-addext "subjectAltName=DNS:${DOMAIN_NAME}"
	chmod 600 "$KEY"
fi

exec "$@"
