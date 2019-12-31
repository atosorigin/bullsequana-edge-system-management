#!/bin/sh


echo "stopping AWX bullsequana edge system management container ...."
docker-compose -f docker_compose_awx.yml down --remove-orphans &>/dev/null
docker-compose -f docker_compose_awx_from_atos_dockerhub.yml down --remove-orphans &>/dev/null

docker container stop `docker container list |grep 'bullsequana-edge-system-management_awx_web' |awk '{ print $1; }'` &>/dev/null
docker container stop `docker container list |grep 'bullsequana-edge-system-management_awx_task' |awk '{ print $1; }'` &>/dev/null
docker container stop `docker container list |grep 'memcached' |awk '{ print $1; }'` &>/dev/null
docker container stop `docker container list |grep 'rabbitmq' |awk '{ print $1; }'` &>/dev/null
docker container stop `docker container list |grep 'dpage/pgadmin4' |awk '{ print $1; }'` &>/dev/null
docker container stop `docker container list |grep -m 1 'awx_postgres' |awk '{ print $1; }'` &>/dev/null

echo "removing dangling MISM containers (containers without images) ...."
docker container prune --force &>/dev/null
echo "removing dangling MISM images (images without containers) ...."
docker image prune --force &>/dev/null
docker volume prune --force &>/dev/null

echo "removing AWX bullsequana edge system management containers ...."
docker container rm -f `docker container list --all |grep 'bullsequana-edge-system-management_awx_web' |awk '{ print $1; }'`
docker container rm -f `docker container list --all |grep 'bullsequana-edge-system-management_awx_task' |awk '{ print $1; }'`
docker container rm -f `docker container list --all |grep 'memcached' |awk '{ print $1; }'`
docker container rm -f `docker container list --all |grep 'rabbitmq' |awk '{ print $1; }'`
docker container rm -f `docker container list --all |grep 'dpage/pgadmin4' |awk '{ print $1; }'`
docker container rm -f `docker container list --all |grep -m 1 'awx_postgres' |awk '{ print $1; }'`

docker image rmi -f `docker images |grep 'bullsequana-edge-system-management_awx_web' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'bullsequana-edge-system-management_awx_task' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'memcached' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'rabbitmq' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'awx_postgres' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'ansible/awx_web' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'ansible/awx_task' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'postgres' |awk '{ print $3; }'`
docker image rmi -f `docker images |grep 'page/pgadmin4' |awk '{ print $3; }'`
