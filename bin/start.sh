#!/bin/bash

DOCKER=/usr/bin/docker.io
DATA_DIR=~/code/docker/ocular8.net/.data

$DOCKER run \
	--detach \
	--publish 30000:9001 \
	--publish 30001:22 \
	--publish 30002:3306 \
	--publish 30003:11300 \
	--name spider_data \
	--volume $DATA_DIR/spider_data/mysql:/var/lib/mysql \
	--hostname data.spider.ocular8.net \
	ocular8.net/spider_data

$DOCKER run \
	--detach \
	--publish 30100:9001 \
	--publish 30101:22 \
	--publish 30102:8080 \
	--hostname crawler01.spider.ocular8.net \
	--name crawler01.spider.ocular8.net \
	ocular8.net/spider

$DOCKER run \
	--detach \
	--publish 53:53 \
	--publish 53:53/udp \
	--hostname dns.`hostname -f` \
	--name dns \
	ocular8.net/dns
