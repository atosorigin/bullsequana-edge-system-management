#!/bin/sh

echo "starting MISM containers ...."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "AWX is available on https://localhost"
echo "Zabbix is available on https://localhost:4443"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to documentation"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
docker-compose -f docker-compose-awx-from-dockerhub.yml up -d

