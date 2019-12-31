#!/bin/sh

. ./versions.sh

. ./remove_awx_containers.sh
. ./remove_zabbix_containers.sh

docker container list
docker images
docker volume list

#echo "removing ansible..."
rm -rf ansible
#echo "removing zabbix..."
rm -rf zabbix
#echo "removing Dockerfiles..."
rm -rf Dockerfiles
#echo "removing packaging..."
rm -rf packaging
#echo "shells"
rm -f *.sh
#echo "yml files"
rm -f *.yml
#echo "md files"
rm -f *.md
#echo "tar files"
rm -f *.tar
#echo "gz files"
rm -f *.gz

