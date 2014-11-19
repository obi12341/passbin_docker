#!/bin/bash
cd /var/www/htdocs/

if [ -n "${MYSQL_DB}" ]; then
	sed "s/{{MYSQL_USER}}/${MYSQL_USER}/" -i Configuration/Production/Settings.yaml
	sed "s/{{MYSQL_PASSWORD}}/${MYSQL_PASSWORD}/" -i Configuration/Production/Settings.yaml
	sed "s/{{MYSQL_DB}}/${MYSQL_DB}/" -i Configuration/Production/Settings.yaml
	sed "s/{{MYSQL_HOST}}/${MYSQL_HOST}/" -i Configuration/Production/Settings.yaml
	if [ ! -n "${MYSQL_PORT}" ]; then
		MYSQL_PORT='3306'
	fi
	sed "s/{{MYSQL_PORT}}/${MYSQL_PORT}/" -i Configuration/Production/Settings.yaml
fi

./flow doctrine:migrate

exec /usr/bin/supervisord
