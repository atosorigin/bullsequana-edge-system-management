#!/bin/sh

echo "stopping MISM containers ...."
docker-compose -f docker-compose-awx.yml down
docker-compose -f docker-compose-zabbix.yml down

echo "removing awx MISM images ...."
docker image rm mism_awx_task
docker image rm mism_awx_web
docker image rm mism_rabbitmq
docker image rm mism_awx_postgres
docker image rm mism_pgadmin
docker rmi `docker images |grep 'rabbitmq' |awk '{ print $3; }'`
docker rmi `docker images |grep 'memcached' |awk '{ print $3; }'`
docker image rm ansible/awx_task
docker image rm ansible/awx_web
docker image rm awx_postgres
docker image rm zabbix-postgres
docker image rm memcached
docker image rm dpage/pgadmin4

echo "removing zabbix MISM images ...."
docker image rm mism_zabbix-server
docker image rm mism_zabbix-web
docker image rm mism_zabbix-agent
docker image rm mism_zabbix-postgres

echo "removing dangling MISM containers (containers without images) ...."
docker container prune --force
echo "removing dangling MISM images (images without containers) ...."
echo "do NOT care Errors if there is NO dangling image"
docker rmi $(docker images |grep 'mism_zabbix-server')
docker rmi $(docker images |grep 'mism_zabbix-web')
docker rmi $(docker images |grep 'mism_zabbix-agent')
docker rmi $(docker images |grep 'mism_zabbix-postgres')
docker image prune --force

echo "removing ansible..."
rm -rf ansible
echo "removing zabbix..."
rm -rf zabbix
echo "removing Dockerfiles..."
rm -rf Dockerfiles
echo "removing postgres backups..."
rm -rf pgadmin
echo "shells"
rm -rf *.sh
rm -f docker-compose-awx.yml
rm -f docker-compose-zabbix.yml
cd ..
rm -rf mism
