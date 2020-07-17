#!/bin/sh

chmod uo+w zabbix/server/externalscripts/openbmc

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

export always_or_no=always
./update_zabbix_containers_restart_option.sh

echo "starting MISM containers ...."
docker-compose -f docker_compose_zabbix.yml up -d
echo "----------------------------------------------------------------"
echo "Zabbix is available on https://localhost:4443"
echo "for more info, refer to github site "
echo "https://github.com/atosorigin/bullsequana-edge-system-management"
echo "----------------------------------------------------------------"

