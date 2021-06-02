#!/bin/sh

. ./versions.sh

export always_or_no=no
./update_zabbix_containers_restart_option.sh

echo "stopping BullSequana Edge zabbix containers ...."
docker-compose -f docker_compose_zabbix_from_atos_dockerhub.yml down

echo "if ever you get trouble to stop containers after a docker migration, try this :"
echo "docker rm -f zabbix-web"
echo "docker rm -f zabbix-agent"
echo "docker rm -f zabbix-server"
echo "docker rm -f zabbix-postgres"

