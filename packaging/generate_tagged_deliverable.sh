#!/bin/sh

unset $mism_version 
echo Enter new version ?
read mism_version

export MISM_BULLSEQUANA_EDGE_VERSION=$mism_version
export MISM_TAG_BULLSEQUANA_EDGE_VERSION=tag
export AWX_BULLSEQUANA_EDGE_VERSION=9.0.1
export RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION=3.8.1-management
export POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION=12.0-alpine
export PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION=4.14
export MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION=1.5.20-alpine

export ZABBIX_BULLSEQUANA_EDGE_VERSION=centos-4.4.1
export POSTGRES_ZABBIX_BULLSEQUANA_EDGE_VERSION=12.0-alpine

echo "git add all"

git add . --all
git commit -m "deliverable $MISM_BULLSEQUANA_EDGE_VERSION"
git push

rm -rf /var/livraisons/$MISM_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management
mkdir /var/livraisons/$MISM_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management
cd /var/livraisons/$MISM_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management

echo "git clone atos"
git clone https://github.com/atosorigin/bullsequana-edge-system-management.git

echo "delete old generation"
# delete local tag
git tag -d $MISM_BULLSEQUANA_EDGE_VERSION
# delete remote tag (eg, GitHub version too)
git push origin :refs/tags/$MISM_BULLSEQUANA_EDGE_VERSION

echo "git tag $MISM_BULLSEQUANA_EDGE_VERSION"
git tag $MISM_BULLSEQUANA_EDGE_VERSION
git push origin master --tags
git checkout $MISM_BULLSEQUANA_EDGE_VERSION

cd bullsequana-edge-system-management

echo "building images tag $MISM_BULLSEQUANA_EDGE_VERSION"
docker-compose -f docker_compose_awx.yml build --no-cache
docker-compose -f docker_compose_zabbix.yml build --no-cache

echo "docker save tag $MISM_BULLSEQUANA_EDGE_VERSION"
docker save -o bullsequana-edge-system-management_zabbix-web.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-web:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o bullsequana-edge-system-management_zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-agent:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o bullsequana-edge-system-management_zabbix-server.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-server:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o bullsequana-edge-system-management_awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_awx_task:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o bullsequana-edge-system-management_awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_awx_web:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o rabbitmq.$MISM_BULLSEQUANA_EDGE_VERSION.tar rabbitmq:$RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION
docker save -o memcached.$MISM_BULLSEQUANA_EDGE_VERSION.tar memcached:$MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION
docker save -o awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar ansible/awx_task:$AWX_BULLSEQUANA_EDGE_VERSION
docker save -o awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar ansible/awx_web:$AWX_BULLSEQUANA_EDGE_VERSION
docker save -o zabbix-server-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar zabbix/zabbix-server-pgsql:$ZABBIX_BULLSEQUANA_EDGE_VERSION
docker save -o zabbix-web-nginx-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar zabbix/zabbix-web-nginx-pgsql:$ZABBIX_BULLSEQUANA_EDGE_VERSION
docker save -o zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar zabbix/zabbix-agent:$ZABBIX_BULLSEQUANA_EDGE_VERSION
docker save -o postgres.$MISM_BULLSEQUANA_EDGE_VERSION.tar postgres:$POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION
docker save -o pgadmin4.$MISM_BULLSEQUANA_EDGE_VERSION.tar dpage/pgadmin4:$PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION

rm -f mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz

echo "docker tar $MISM_BULLSEQUANA_EDGE_VERSION"
tar -czvf mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz *
echo "terminated : docker mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz file generated in /var/livraisons/$MISM_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management"



