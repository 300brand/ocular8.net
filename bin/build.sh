#!/bin/bash

DOCKER=/usr/bin/docker.io

BUILD_ORDER=(
	dns
	base
	spider_data
	spider
	mongo
	mongo-data-rs0
)

for BUILD in ${BUILD_ORDER[@]}; do
	$DOCKER build -t ocular8.net/$BUILD $BUILD
	RET=$?
	if [ $RET -ne 0 ]; then
		exit $RET
	fi
done