#!/bin/sh

echo Enter new version?
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

cd /var
rm /var/$MISM_TAG_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management
cd /var/$MISM_TAG_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management

git clone https://github.com/atosorigin/bullsequana-edge-system-management.git

cd bullsequana-edge-system-management

git tag $MISM_BULLSEQUANA_EDGE_VERSION
git push origin master --tags

git checkout $MISM_BULLSEQUANA_EDGE_VERSION

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

rm mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz

tar -czvf mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz *


