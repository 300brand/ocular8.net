#!/bin/bash

DOCKER=/usr/bin/docker.io

BUILD_ORDER=(
	dns
	base
	beanstalk
	spider_data
	spider
	mongo
	mongo-data-rs0
	service
	service-web
	service-processing
)

for BUILD in ${BUILD_ORDER[@]}; do
	$DOCKER build -t ocular8.net/$BUILD $BUILD
	RET=$?
	if [ $RET -ne 0 ]; then
		exit $RET
	fi
done
