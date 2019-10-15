#!/bin/sh

echo "MISM_BULLSEQUANA_EDGE_VERSION environment variable is :"
docker exec -it zabbix-server env |grep MISM_BULLSEQUANA_EDGE_VERSION


