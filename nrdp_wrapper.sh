#!/bin/bash
print_nrdp() {
	CMD=$(eval $1)
	EXIT_CODE=$?
	SERVICENAME=$2
	IFS=$'|'; arrIN=($CMD); unset IFS;
    echo "$HOST;$SERVICENAME;$EXIT_CODE;${arrIN[0]//;/ \-}"

}

SERVICENAME=$1
HOST=$(hostname -f)
if test -f "/usr/local/nagios/libexec/${@:2}"; then
	COMMAND="/usr/local/nagios/libexec/${@:2}"
else
	COMMAND="/usr/lib/nagios/plugins/${@:2}"
fi
print_nrdp "$COMMAND" "$SERVICENAME"


