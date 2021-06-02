#!/bin/sh

. ./proxy.sh
. ./versions.sh

export always_or_no=always
./update_awx_containers_restart_option.sh

echo "starting BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker_compose_awx_from_atos_dockerhub.yml up -d
echo "----------------------------------------------------------------"
echo "AWX is available on https://localhost"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to github site "
echo "https://github.com/atosorigin/bullsequana-edge-system-management"
echo "----------------------------------------------------------------"

