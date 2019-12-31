#!/bin/sh

echo "stopping Zabbix bullsequana edge system management containers ...."
docker-compose -f docker_compose_zabbix.yml down  --remove-orphans &>/dev/null
docker-compose -f docker_compose_zabbix_from_atos_dockerhub.yml down --remove-orphans &>/dev/null

docker container stop `docker container list |grep 'bullsequana-edge-system-management_zabbix-server' |awk '{ print $1; }'` &>/dev/null
docker container stop `docker container list |grep 'bullsequana-edge-system-management_zabbix-agent' |awk '{ print $1; }'` &>/dev/null
docker container stop `docker container list |grep 'bullsequana-edge-system-management_zabbix-web' |awk '{ print $1; }'` &>/dev/null
docker container stop `docker container list |grep -m 1 'zabbix-postgres' |awk '{ print $1; }'`&>/dev/null

echo "removing dangling MISM containers (containers without images) ...."
docker container prune --force &>/dev/null
echo "removing dangling MISM images (images without containers) ...."
docker image prune --force &>/dev/null
docker volume prune --force &>/dev/null

echo "removing Zabbix bullsequana edge system management containers ...."
docker container rm -f `docker container list --all |grep 'bullsequana-edge-system-management_zabbix-server' |awk '{ print $1; }'`
docker container rm -f `docker container list --all |grep 'bullsequana-edge-system-management_zabbix-agent' |awk '{ print $1; }'`
docker container rm -f `docker container list --all |grep 'bullsequana-edge-system-management_zabbix-web' |awk '{ print $1; }'`
docker container rm -f `docker container list --all |grep -m 1 'zabbix-postgres' |awk '{ print $1; }'`

docker image rmi -f `docker images |grep 'bullsequana-edge-system-management_zabbix-server' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'bullsequana-edge-system-management_zabbix-agent' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'bullsequana-edge-system-management_zabbix-web' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'zabbix-postgres' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'zabbix/zabbix-web-nginx-pgsql' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'zabbix/zabbix-server-pgsql' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'zabbix/zabbix-agent' |awk '{ print $3; }'`

