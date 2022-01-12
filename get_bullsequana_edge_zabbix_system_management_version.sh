#!/bin/sh

echo "BullSequana Edge System Management Light version "
docker exec -it zabbix-server env |grep MISM_BULLSEQUANA_EDGE_VERSION
tail -1 zabbix/readme.md
echo