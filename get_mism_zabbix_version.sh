#!/bin/sh

echo "MISM_VERSION environment variable is :"
docker exec -it zabbix-server env |grep MISM_VERSION


