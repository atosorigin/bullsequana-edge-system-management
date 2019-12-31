#!/bin/sh

. ./proxy.sh
. ./versions.sh

echo "starting MISM containers ...."
docker-compose -f docker_compose_zabbix.yml up -d
echo "----------------------------------------------------------------"
echo "Zabbix is available on https://localhost:4443"
echo "for more info, refer to github site "
echo "https://github.com/atosorigin/bullsequana-edge-system-management"
echo "----------------------------------------------------------------"

