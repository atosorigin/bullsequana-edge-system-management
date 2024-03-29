#!/bin/sh

rm -f install_zabbix.sh
rm -f start_zabbix.sh
rm -f stop_zabbix.sh

. ./check_prerequisites.sh
. ./remove_zabbix_containers_and_images.sh

chmod ugo+w zabbix/server/externalscripts/openbmc

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

. ./proxy.sh
. ./versions.sh

rm -f install.sh install_zabbix.sh
rm -f start.sh start_zabbix.sh
rm -f stop.sh stop_zabbix.sh

echo "starting BullSequana Edge Zabbix containers ...."
docker-compose -f docker_compose_zabbix_from_atos_dockerhub.yml up -d

echo "---------------------------------------------------------------------------------------------------"
echo "Zabbix is now available on https://localhost:4443"
echo "for more info, refer to github site https://github.com/atosorigin/bullsequana-edge-system-management"
echo "----------------------------------------------------------------------------------------------------"



