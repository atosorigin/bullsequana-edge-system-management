#!/bin/sh

###############################################################################################################
# this script builds from docker-compose-awx.yml 
# build context is Dockerfiles/Dockerfile-awx_xxx file
###############################################################################################################

. ./check_prerequisites.sh
. ./remove_awx_containers.sh
. ./versions.sh

export docker_image=`docker images |grep 'bullsequana-edge-system-management_awx_web' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f bullsequana-edge-system-management_awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading Bull AWX web image ...."
    docker load --input bullsequana-edge-system-management_awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep 'bullsequana-edge-system-management_awx_task' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f bullsequana-edge-system-management_awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading Bull AWX task image ...."
    docker load --input bullsequana-edge-system-management_awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep 'ansible/awx_web' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading ansible/awx_web image ...."
    docker load --input awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep 'ansible/awx_task' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading ansible/awx_task image ...."
    docker load --input awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar
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

export docker_image=`docker images |grep 'memcached' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f memcached.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading memcached $MISM_BULLSEQUANA_EDGE_VERSION image ...."
    docker load --input memcached.$MISM_BULLSEQUANA_EDGE_VERSION.tar
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

echo "building BullSequana Edge Ansible AWX containers and images ...."
docker-compose -f docker_compose_awx.yml build

echo "----------------------------------------------------------------------------------------------------"
echo "now edit install_awx.sh"
echo -e "\033[32mcomment the line . ./remove_awx_containers.sh\033[0m"
echo "BEFORE running ./install_awx.sh"
echo "----------------------------------------------------------------------------------------------------"

