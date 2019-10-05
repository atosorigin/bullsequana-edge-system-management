#!/bin/sh

echo "starting MISM zabbix containers ...."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "Zabbix is available on https://localhost:4443"
echo "for more info, refer to documentation"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
docker-compose -f docker-compose-zabbix.yml up -d

