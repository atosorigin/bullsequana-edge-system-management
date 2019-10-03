#!/bin/sh

echo "stopping MISM zabbix containers ...."
docker-compose -f docker-compose-mism-zabbix.yml down

