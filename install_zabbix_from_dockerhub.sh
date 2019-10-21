#!/bin/sh

export HTTP_PROXY=$HTTP_PROXY
export HTTPS_PROXY=$HTTPS_PROXY
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

echo "cloning BullSequana Edge Ansible AWX containers ...."
git clone "https://www.github.com/frsauvage/MISM.git"
echo "starting BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker-compose-awx-from-dockerhub.yml up -d

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "now wait 10 minutes for the migration to complete...."
echo "check the login page at https://localhost"
echo "and run ./add_playbooks.sh"
echo "AWX is available on https://localhost"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to documentation"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"



