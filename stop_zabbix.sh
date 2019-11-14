#!/bin/sh

echo "stopping BullSequana Edge zabbix containers ...."
docker-compose -f docker_compose_zabbix.yml down

