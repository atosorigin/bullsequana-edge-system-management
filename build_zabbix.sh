###############################################################################################################
# this script builds from docker-compose-awx.yml 
# build context is Dockerfiles/Dockerfile-awx_xxx.tag or .latest file
###############################################################################################################

echo -e "This script is usefull if you change some Zabbix Dockerfiles before running"
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

#. ./check_prerequisites.sh
#. ./remove_zabbix_containers.sh
. ./versions.sh

echo "building BullSequana Edge Zabbix containers and images ...."
export REGISTRY=zabbix
docker-compose -f docker_compose_zabbix.yml build \
 --build-arg MISM_BULLSEQUANA_EDGE_VERSION=$MISM_BULLSEQUANA_EDGE_VERSION \
 --build-arg REGISTRY=$REGISTRY \
 --build-arg BASE_IMAGE_ZABBIX=$BASE_IMAGE_ZABBIX \
 --build-arg TAG_ZABBIX=$ZABBIX_BULLSEQUANA_EDGE_VERSION \
 --build-arg BASE_IMAGE_ZABBIX_WEB=$BASE_IMAGE_ZABBIX_WEB \
 --build-arg BASE_IMAGE_ZABBIX_AGENT=$BASE_IMAGE_ZABBIX_AGENT \
 --no-cache

#echo "saving BullSequana Edge Zabbix containers and images in tar files ...."
#echo -e "\033[31mit will take several minutes\033[0m"
#docker save -o bullsequana-edge-system-management_zabbix-web.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-web:$MISM_BULLSEQUANA_EDGE_VERSION
#docker save -o bullsequana-edge-system-management_zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-agent:$MISM_BULLSEQUANA_EDGE_VERSION
#docker save -o bullsequana-edge-system-management_zabbix-server.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-server:$MISM_BULLSEQUANA_EDGE_VERSION

#echo "... save completed"
#echo "----------------------------------------------------------------------------------------------------"
#echo -e "\033[31mnow you can run ./install_zabbix.sh... enjoy your customization !!\033[0m"
#echo "----------------------------------------------------------------------------------------------------"

