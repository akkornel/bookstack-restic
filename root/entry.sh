#!/bin/bash
# vim: ts=4 sw=4 noet

set -eu
set -o pipefail

function usage {
	echo "usage: $0 COMMAND ARGS"
	echo
	echo "The following commands are available:"
	echo "- cron: Run the cron daemon (will not exit)"
	echo "- mysql: Run the MariaDB client"
	echo "- restic: Run the Restic client"
}

# Which program should we run?
if [ "${1:-x}" = "x" ]; then
	usage
	exit 1
fi

case $1 in
	cron)
		exec crond -f
		;;
	mysql)
		exec mariadb "${@:2}"
		;;
	restic)
		exec restic "${@:2}"
		;;
	*)
		usage
		exit 1
		;;
esac
