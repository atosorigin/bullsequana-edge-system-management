#!/bin/sh

rm -f install_awx.sh
rm -f start_awx.sh
rm -f stop_awx.sh

. ./check_prerequisites.sh
. ./remove_awx_containers_and_images.sh
. ./proxy.sh
. ./versions.sh

echo "starting BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker_compose_awx_from_atos_dockerhub.yml up -d

rm -f install.sh install_awx.sh
rm -f start.sh start_awx.sh
rm -f stop.sh stop_awx.sh

echo "----------------------------------------------------------------------------------------------------"
echo "now wait 10 minutes for the migration to complete...."
echo "check the login page at https://localhost"
echo "and run ./add_awx_playbooks.sh"
echo "AWX is available on https://localhost"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to github site https://github.com/atosorigin/bullsequana-edge-system-management"
echo "----------------------------------------------------------------------------------------------------"

