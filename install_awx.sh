#!/bin/sh

export NO_PROXY=$NO_PROXY
export HTTP_PROXY=$HTTP_PROXY
export HTTPS_PROXY=$HTTPS_PROXY

export MISM_BULLSEQUANA_EDGE_VERSION=2.0.1
export MISM_TAG_BULLSEQUANA_EDGE_VERSION=tag
export AWX_BULLSEQUANA_EDGE_VERSION=9.0.1
export RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION=3.8.1-management
export POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION=12.0-alpine
export PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION=4.14
export MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION=1.5.20-alpine

export docker_image=`docker images |grep 'bullsequana-edge-system-management_awx_web' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f bullsequana-edge-system-management_awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading AWX web image ...."
    docker load --input bullsequana-edge-system-management_awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep 'bullsequana-edge-system-management_awx_task' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f bullsequana-edge-system-management_awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading AWX task image ...."
    docker load --input bullsequana-edge-system-management_awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep 'rabbitmq' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f rabbitmq.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading rabbitmq $MISM_BULLSEQUANA_EDGE_VERSION image ...."
    docker load --input rabbitmq.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep 'postgres' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f postgres.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading postgres $MISM_BULLSEQUANA_EDGE_VERSION image ...."
    docker load --input postgres.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep 'pgadmin4' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f pgadmin4.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading pgadmin4 $MISM_BULLSEQUANA_EDGE_VERSION image ...."
    docker load --input pgadmin4.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

echo "starting BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker_compose_awx.yml up -d

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "now wait 10 minutes for the migration to complete...."
echo "check the login page at https://localhost"
echo "and run ./add_playbooks.sh"
echo "AWX is available on https://localhost"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to github site https://github.com/atosorigin/bullsequana-edge-system-management ansible part"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"



