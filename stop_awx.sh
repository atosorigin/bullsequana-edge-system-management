#!/bin/sh

. ./versions.sh

export always_or_no=no
./update_awx_containers_restart_option.sh

echo "stopping BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker_compose_awx.yml down

echo "if ever you get trouble to stop containers after a docker migration, try this :"
echo "docker rm -f awx_web"
echo "docker rm -f awx_task"
echo "docker rm -f awx_memcached"
echo "docker rm -f awx_rabbitmq"
echo "docker rm -f awx_postgres"
echo "docker rm -f pgadmin"

