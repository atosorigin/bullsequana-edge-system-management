#!/bin/sh

echo "stopping MISM containers ...."
docker-compose -f docker-compose-awx.yml down
docker-compose -f docker-compose-zabbix.yml down

echo "removing awx MISM images ...."
docker image rm -f mism_awx_task
docker image rm -f mism_awx_web
docker image rm ansible/awx_task
docker image rm ansible/awx_web
docker image rm dpage/pgadmin4
docker rmi -f `docker images |grep 'postgres' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'memcached' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'rabbitmq' |awk '{ print $3; }'`

echo "removing zabbix MISM images ...."
docker image rm -f mism_zabbix-server
docker image rm -f mism_zabbix-web
docker image rm -f mism_zabbix-agent
docker rmi -f `docker images |grep 'zabbix/zabbix-web-nginx-pgsql' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'zabbix/zabbix-agent' |awk '{ print $3; }'`
docker rmi -f `docker images |grep 'zabbix/zabbix-server-pgsql' |awk '{ print $3; }'`

echo "removing dangling MISM containers (containers without images) ...."
docker container prune --force
echo "removing dangling MISM images (images without containers) ...."
echo "do NOT care Errors if there is NO dangling image"
docker rmi -f $(docker images |grep 'mism_zabbix-server')
docker rmi -f $(docker images |grep 'mism_zabbix-web')
docker rmi -f $(docker images |grep 'mism_zabbix-agent')
docker rmi -f $(docker images |grep 'mism_zabbix-postgres')
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
