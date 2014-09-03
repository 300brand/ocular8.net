#!/bin/bash

DOCKER=$( [[ -x /usr/bin/docker.io ]] && echo /usr/bin/docker.io || echo /usr/bin/docker )

BUILD_ORDER=(
	dns
	base
	etcd
	spider-data
	spider
	mongo
	mongo-data-rs0
	service
	mongo-monitoring
)

for BUILD in ${BUILD_ORDER[@]}; do
	$DOCKER build -t docker.ocular8.net/$BUILD $BUILD
	RET=$?
	if [ $RET -ne 0 ]; then
		exit $RET
	fi
	$DOCKER push docker.ocular8.net/$BUILD
	RET=$?
	if [ $RET -ne 0 ]; then
		exit $RET
	fi
done
