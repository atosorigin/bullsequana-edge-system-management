#!/bin/sh

echo "stopping BullSequana Edge zabbix containers ...."
docker-compose -f docker-compose-zabbix-from-dockerhub.yml down
