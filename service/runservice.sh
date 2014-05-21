#!/bin/bash

SERVICE=$1
if [ -z $SERVICE ]; then
	echo "No service specified" 1>&2
	exit 1
fi

IP=`hostname -i`

LAST_PPROF_PORT=`netstat -tln | grep -o ':60.. ' | tr -d ': ' | sort -n | tail -n1`

if [ -z $LAST_PPROF_PORT ]; then
	PPROF_PORT=6060
else
	PPROF_PORT=$(($LAST_PPROF_PORT + 1))
fi

# http://riccomini.name/posts/linux/2012-09-25-kill-subprocesses-linux-bash/
trap 'kill $(jobs -p)' EXIT

/usr/local/bin/coverageservices \
	-config=/etc/coverage.toml \
	-disgo.serve=$IP:10000 \
	-pprof.listen=:$PPROF_PORT \
	-${SERVICE}.enabled=true

exit $?
