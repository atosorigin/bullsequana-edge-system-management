#!/bin/sh

# restore images ...
#echo "load mism_rabbitmq ..."
#docker load -i mism_rabbitmq.tar
#echo "load mism_awx_postgres ..."
#docker load -i mism_awx_postgres.tar
#echo "load mism_memcached ..."
#docker load -i mism_memcached.tar
#echo "load mism_awx_web ..."
#docker load -i mism_awx_web.tar
#echo "load mism_awx_task ..."
#docker load -i mism_awx_task.tar
echo "building BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker-compose-awx.yml build

echo "starting BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker-compose-awx.yml up -d

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "now wait 10 minutes for the migration to complete...."
echo "check the login page at https://localhost"
echo "and run ./add_playbooks.sh"
echo "AWX is available on https://localhost"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to documentation"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"



