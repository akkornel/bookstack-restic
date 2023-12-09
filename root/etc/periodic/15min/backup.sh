#!/bin/bash
# vim: ts=4 sw=4 noet

# This script runs our backups!

set -eu
set -o pipefail

# PART 0: Check environment
if [ ${MYSQL_HOST:-x} = 'x' ]; then
	echo 'MYSQL_HOST environment variable is missing!'
	exit 1
fi
if [ ${DB_PASS_FILE:-x} = 'x' ]; then
	echo 'DB_PASS_FILE environment variable is missing!'
	exit 1
fi
if [ ${DB_DATABASE:-x} = 'x' ]; then
	echo 'DB_DATABASE environment variable is missing!'
	exit 1
fi
if [ ${RETAIN_HOURLY:-x} = 'x' ]; then
	echo 'RETAIN_HOURLY environment variable is missing!'
	exit 1
fi
if [ ${RETAIN_DAILY:-x} = 'x' ]; then
	echo 'RETAIN_DAILY environment variable is missing!'
	exit 1
fi
if [ ${RETAIN_WEEKLY:-x} = 'x' ]; then
	echo 'RETAIN_WEEKLY environment variable is missing!'
	exit 1
fi
if [ ${RETAIN_MONTHLY:-x} = 'x' ]; then
	echo 'RETAIN_MONTHLY environment variable is missing!'
	exit 1
fi
if [ ${RETAIN_YEARLY:-x} = 'x' ]; then
	echo 'RETAIN_YEARLY environment variable is missing!'
	exit 1
fi

# PART 1: Dump the database into the Bookstack directory
mysqldump --host=${MYSQL_HOST} --password=$(cat $DB_PASS_FILE) --databases mysql > /bookstack/backups/mysql.sql
mysqldump --host=${MYSQL_HOST} --password=$(cat $DB_PASS_FILE) --databases ${DB_DATABASE} > /bookstack/backups/bookstack.sql

# PART 2: Run a Restic backup of the Bookstack directory
restic backup \
	/bookstack/BOOKSTACK_APP_KEY.txt \
	/bookstack/backups/mysql.sql /bookstack/backups/bookstack.sql \
	/bookstack/keys/ /bookstack/letsencrypt/ \
	/bookstack/www/files /bookstack/www/images /bookstack/www/themes \
	/bookstack/www/uploads

# PART 3: Clean up snapshots
restic forget --keep-hourly ${RETAIN_HOURLY} --keep-daily ${RETAIN_DAILY} \
	--keep-weekly ${RETAIN_WEEKLY} --keep-monthly ${RETAIN_MONTHLY} \
	--keep-yearly ${RETAIN_YEARLY}
