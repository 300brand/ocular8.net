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

PRIVATE_PORTS=( 22 9001 4001 7001 8080 $(seq 6060 6069) $(seq 10000 10009) )
declare -a PORTS
declare -a PUBLISH

PUBLISH[9200]="--publish 9200:9200"
PUBLISH[9300]="--publish 9300:9300"

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
	docker.ocular8.net/mongo-data-rs0

mkdir -p /home/data/etcd
ETCD_PORT=${PORTS[4001]}
ETCD_SERVERS=http://192.168.20.17:50${ETCD_PORT:2},http://192.168.20.18:51${ETCD_PORT:2},http://192.168.20.19:52${ETCD_PORT:2}

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
	docker.ocular8.net/etcd

docker run \
	--detach \
	--hostname service.$FULL_HOST \
	--memory 2g \
	--name service \
	--env MACHINE_IP=$IP \
	--env ETCD_SERVER=$ETCD_SERVERS \
	${PUBLISH[22]} \
	${PUBLISH[8080]} \
	${PUBLISH[9001]} \
	${PUBLISH[6060]} \
	${PUBLISH[6061]} \
	${PUBLISH[6062]} \
	${PUBLISH[6063]} \
	${PUBLISH[6064]} \
	${PUBLISH[6065]} \
	${PUBLISH[6066]} \
	${PUBLISH[6067]} \
	${PUBLISH[6068]} \
	${PUBLISH[6069]} \
	${PUBLISH[10000]} \
	${PUBLISH[10001]} \
	${PUBLISH[10002]} \
	${PUBLISH[10003]} \
	${PUBLISH[10004]} \
	${PUBLISH[10005]} \
	${PUBLISH[10006]} \
	${PUBLISH[10007]} \
	${PUBLISH[10008]} \
	${PUBLISH[10009]} \
	docker.ocular8.net/service

docker run \
	--detach \
	--hostname mongo-monitor-$(hostname) \
	--memory 256m \
	--name mongo-monitoring \
	--env MACHINE_IP=$IP \
	${PUBLISH[22]} \
	${PUBLISH[9001]} \
	docker.ocular8.net/mongo-monitoring

mkdir -p ${DATA_DIR}/elastic
ELASTIC_CONFIG=${DATA_DIR}/elastic/elasticsearch.yml
cp `dirname $0`/../elastic/elasticsearch.yml $ELASTIC_CONFIG
sed -i s/@PUBLISH_HOST@/$IP/ $ELASTIC_CONFIG
sed -i s/@NODE_NAME@/$IP/ $ELASTIC_CONFIG
if [ $IP != "192.168.20.17" ]; then
	sed -i s/@PING@/192.168.20.17/ $ELASTIC_CONFIG
fi
if [ $IP != "192.168.20.18" ]; then
	sed -i s/@PING@/192.168.20.18/ $ELASTIC_CONFIG
fi
if [ $IP != "192.168.20.19" ]; then
	sed -i s/@PING@/192.168.20.19/ $ELASTIC_CONFIG
fi

docker run \
	--detach \
	--hostname elastic-$(hostname) \
	--name elasticsearch \
	--env MACHINE_IP=$IP \
	${PUBLISH[9200]} \
	${PUBLISH[9300]} \
	--volume ${DATA_DIR}/elastic:/data \
	dockerfile/elasticsearch \
	/elasticsearch/bin/elasticsearch \
	-Des.config=/data/elasticsearch.yml
