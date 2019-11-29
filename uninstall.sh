#!/bin/sh

echo "stopping bullsequana edge system management containers ...."
docker-compose -f docker_compose_awx.yml down --remove-orphans
docker-compose -f docker_compose_zabbix.yml down  --remove-orphans
docker-compose -f docker_compose_awx_from_atos_dockerhub.yml down --remove-orphans
docker-compose -f docker_compose_zabbix_from_atos_dockerhub.yml down --remove-orphans

echo "removing bullsequana edge system management images ...."
docker rmi -f `docker images |grep 'bullsequana-edge-system-management' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'bull-sequana-edge' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'ansible/awx' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'zabbix/zabbix' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'rabbitmq' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'memcached' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'postgres' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'dpage/pgadmin4 ' |awk '{ print $3; }'`

echo "removing dangling MISM containers (containers without images) ...."
docker container prune --force

echo "removing dangling MISM images (images without containers) ...."
echo "do NOT care Errors if there is NO dangling image"
docker image prune --force
docker volume prune --force

docker container list
docker images
docker volume list

#echo "removing ansible..."
rm -rf ansible
#echo "removing zabbix..."
rm -rf zabbix
#echo "removing Dockerfiles..."
rm -rf Dockerfiles
#echo "removing postgres backups..."
rm -rf ansible/pgadmin
rm -rf zabbix/pgadmin
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

