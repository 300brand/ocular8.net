#!/bin/bash

DOCKER=/usr/bin/docker.io
DATA_DIR=/home/data
IP=$(ip addr show dev $(ip route list table main | awk '$1 == "default" {print $NF}') | awk '$1 == "inet" { sub(/\/[0-9]+/, "", $2); print $2 }')
FULL_HOST=$(hostname).ocular8.net

PORT_PREFIX=500
if [ $HOSTNAME == "highland" ]; then
	PORT_PREFIX=$(($PORT_PREFIX + 10))
elif [ $HOSTNAME == "island" ]; then
	PORT_PREFIX=$(($PORT_PREFIX + 20))
fi

PRIVATE_PORTS=( 22 9001 4001 7001 8080 $(seq 6060 6067) $(seq 10000 10007) )
declare -a PORTS
declare -a PUBLISH

port () {
	printf "%3d%02d" $PORT_PREFIX $1
}

setports () {
	for I in $(seq 0 $((${#PRIVATE_PORTS[@]} - 1))); do
		P=${PRIVATE_PORTS[$I]}
		PORT=$(port $I)
		PORTMAP=${PORT}:${P}
		PORTS[$P]=$PORT
		PUBLISH[$P]="--publish $PORTMAP --env PORT_${P}=${PORT}"
	done
}

docker () {
	$DOCKER $@
	PORT_PREFIX=$(($PORT_PREFIX + 1))
	setports
}

setports

mkdir -p /home/data/mongo/rs0
docker run \
	--detach \
	--hostname rs0-$(hostname).$FULL_HOST \
	--memory 16g \
	--name mongod-rs0 \
	--env MACHINE_IP=$IP \
	${PUBLISH[22]} \
	${PUBLISH[9001]} \
	--publish 27017:27017 \
	--volume ${DATA_DIR}/mongo:/data \
	ocular8.net/mongo-data-rs0

mkdir -p /home/data/etcd
ETCD_PORT=${PORTS[4001]}
docker run \
	--detach \
	--hostname etcd.$FULL_HOST \
	--memory 2g \
	--name etcd \
	--env MACHINE_IP=$IP \
	--env DISCOVERY=https://discovery.etcd.io/ae99102a81a29345e515cfd48ccad561 \
	--env FULL_HOSTNAME=etcd.$FULL_HOST \
	${PUBLISH[22]} \
	${PUBLISH[4001]} \
	${PUBLISH[7001]} \
	${PUBLISH[9001]} \
	--volume ${DATA_DIR}/etcd:/data \
	ocular8.net/etcd

docker run \
	--detach \
	--hostname service-web.$FULL_HOST \
	--memory 2g \
	--name service-web \
	--env MACHINE_IP=$IP \
	--env ETCD_SERVER=http://etcd.${FULL_HOST}:${ETCD_PORT} \
	${PUBLISH[22]} \
	${PUBLISH[6060]} \
	${PUBLISH[6061]} \
	${PUBLISH[8080]} \
	${PUBLISH[9001]} \
	${PUBLISH[10000]} \
	${PUBLISH[10001]} \
	ocular8.net/service-web

docker run \
	--detach \
	--hostname service-processing.$FULL_HOST \
	--memory 2g \
	--name service-processing \
	--env MACHINE_IP=$IP \
	--env ETCD_SERVER=http://etcd.${FULL_HOST}:${ETCD_PORT} \
	${PUBLISH[22]} \
	${PUBLISH[9001]} \
	${PUBLISH[6060]} \
	${PUBLISH[6061]} \
	${PUBLISH[6062]} \
	${PUBLISH[6063]} \
	${PUBLISH[6064]} \
	${PUBLISH[6065]} \
	${PUBLISH[6066]} \
	${PUBLISH[6067]} \
	${PUBLISH[10000]} \
	${PUBLISH[10001]} \
	${PUBLISH[10002]} \
	${PUBLISH[10003]} \
	${PUBLISH[10004]} \
	${PUBLISH[10005]} \
	${PUBLISH[10006]} \
	${PUBLISH[10007]} \
	ocular8.net/service-processing

# docker run \
# 	--detach \
# 	--publish 30000:9001 \
# 	--publish 30001:22 \
# 	--publish 30002:3306 \
# 	--publish 30003:11300 \
# 	--name spider_data \
# 	--volume $DATA_DIR/spider_data/mysql:/var/lib/mysql \
# 	--hostname data.spider.ocular8.net \
# 	ocular8.net/spider_data

# docker run \
# 	--detach \
# 	--publish 30100:9001 \
# 	--publish 30101:22 \
# 	--publish 30102:8080 \
# 	--hostname crawler01.spider.ocular8.net \
# 	--name crawler01.spider.ocular8.net \
# 	ocular8.net/spider

# docker run \
# 	--detach \
# 	--publish 53:53 \
# 	--publish 53:53/udp \
# 	--hostname dns.`hostname -f` \
# 	--name dns \
# 	ocular8.net/dns
