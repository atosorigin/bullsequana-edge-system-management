#!/bin/sh

###############################################################################################################
# this script builds from docker-compose-awx.yml 
# build context is Dockerfiles/Dockerfile-awx_xxx.tag or .latest file
###############################################################################################################

echo -e "This script is usefull if you change some AWX Dockerfiles before running"
echo -e "\033[31m!!!!!!! You will lost the WARRANTY as you change the Dockerfiles at your own risk !!!!!!!\033[0m"

continuebuild()
{
  echo "tar files will be overwritten"
  echo -e "\033[32myou can always get the original tar file from github to have WARRANTY again\033[0m"
}

while true; do
    read -p "Do you wish to continue and build your own Dockerfiles ? y yes / n no: " yn
    case $yn in
        [Yy]* ) continuebuild; break;;
        [Nn]* ) exit; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

. ./check_prerequisites.sh
. ./remove_awx_containers.sh
. ./versions.sh

echo "building BullSequana Edge Ansible AWX containers and images ...."
docker-compose -f docker_compose_awx.yml build

echo "saving BullSequana Edge Ansible AWX containers and images in tar files ...."
echo -e "\033[31mit will take several minutes\033[0m"
docker save -o bullsequana-edge-system-management_awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_awx_task:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o bullsequana-edge-system-management_awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_awx_web:$MISM_BULLSEQUANA_EDGE_VERSION

echo "... save completed"
echo "----------------------------------------------------------------------------------------------------"
echo -e "\033[31mnow you can run ./install_awx.sh... enjoy your customization !!\033[0m"
echo "----------------------------------------------------------------------------------------------------"

