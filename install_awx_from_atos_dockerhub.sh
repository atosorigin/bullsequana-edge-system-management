#!/bin/sh

. ./check_prerequisites.sh
. ./remove_awx_containers.sh
. ./proxy.sh
. ./versions.sh

echo "starting BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker_compose_awx_from_atos_dockerhub.yml up -d

echo "----------------------------------------------------------------------------------------------------"
echo "AWX is available on https://localhost"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to github site https://github.com/atosorigin/bullsequana-edge-system-management"
echo "----------------------------------------------------------------------------------------------------"



