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

# PART 1: Dump the database into the Bookstack directory
mysqldump --host=${MYSQL_HOST} --password=$(cat $DB_PASS_FILE) --databases mysql > /bookstack/backups/mysql.sql
mysqldump --host=${MYSQL_HOST} --password=$(cat $DB_PASS_FILE) --databases ${DB_DATABASE} > /bookstack/backups/bookstack.sql

# PART 2: Run a Restic backup of the Bookstack directory
