#!/bin/sh

echo "removing data..."
rm -f mism*.tar
rm -f mism*.gz
echo "removing data..."
rm -rf ansible/pgdata
rm -rf zabbix/pgdata
echo "removing postgres backups..."
rm -rf pgadmin
echo "removing ansible directory..."
rm -rf ansible
echo "removing zabbix directory..."
rm -rf zabbix
echo "shells"
rm -rf *.sh
rm -f docker-compose-mism-awx.yml
rm -f docker-compose-mism-zabbix.yml
cd ..
rm -rf mism
