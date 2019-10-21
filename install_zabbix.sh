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

set -euo pipefail

if filename=$(readlink /etc/localtime); then
    # /etc/localtime is a symlink as expected
    export timezone=${filename#*zoneinfo/}
    if [[ $timezone = "$filename" || ! $timezone =~ ^[^/]+/[^/]+$ ]]; then
        # not pointing to expected location or not Region/City
        >&2 echo "$filename points to an unexpected location"
        exit 1
    fi
else  # compare files by contents
    # https://stackoverflow.com/questions/12521114/getting-the-canonical-time-zone-name-in-shell-script#comment88637393_12523283
     export timezone=$(find /usr/share/zoneinfo -type f ! -regex ".*/Etc/.*" -exec cmp -s {} /etc/localtime \; -print | sed -e 's@.*/zoneinfo/@@' | head -n1)
fi

echo $timezone

echo "building BullSequana Edge Zabbix containers ...."
#docker-compose -f docker-compose-zabbix.yml build

echo "starting BullSequana Edge Zabbix containers ...."
docker-compose -f docker-compose-zabbix.yml up 
#-d
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "Zabbix is available on https://localhost:4443"
echo "for more info, refer to documentation"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"



