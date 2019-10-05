#!/bin/sh

# restore images ...
#echo "load mism_zabbix-server ..."
#docker load -i mism_zabbix-server.tar
#echo "load mism_zabbix-agent ..."
#docker load -i mism_zabbix-agent.tar
#echo "load mism_zabbix-web ..."
#docker load -i mism_zabbix-web.tar
#echo "load mism_pgadmin ..."
#docker load -i mism_pgadmin.tar
#echo "load mism_zabbix-postgres ..."
#docker load -i mism_zabbix-postgres.tar

echo "building BullSequana Edge Zabbix containers ...."
docker-compose -f docker-compose-zabbix.yml build

echo "starting BullSequana Edge Zabbix containers ...."
docker-compose -f docker-compose-zabbix.yml up -d
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "Zabbix is available on https://localhost:4443"
echo "for more info, refer to documentation"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"



