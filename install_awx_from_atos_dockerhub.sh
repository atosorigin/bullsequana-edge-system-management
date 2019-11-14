#!/bin/sh

export NO_PROXY=$NO_PROXY
export HTTP_PROXY=$HTTP_PROXY
export HTTPS_PROXY=$HTTPS_PROXY

export MISM_BULLSEQUANA_EDGE_VERSION=2.0.1
export AWX_BULLSEQUANA_EDGE_VERSION=9.0.1
export RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION=3.8.1-management
export POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION=12.0-alpine
export PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION=4.14
export MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION=1.5.20-alpine

echo "starting BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker_compose_awx_from_atos_dockerhub.yml up -d

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "AWX is available on https://localhost"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to github site https://github.com/atosorigin/bullsequana-edge-system-management ansible part"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"



