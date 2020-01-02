#!/bin/sh

echo "stopping Zabbix bullsequana edge system management containers"
docker-compose -f docker_compose_zabbix.yml down  &>/dev/null
docker-compose -f docker_compose_zabbix_from_atos_dockerhub.yml down &>/dev/null

echo "removing dangling MISM containers (containers without images)"
docker container prune --force &>/dev/null
echo "removing dangling MISM images (images without containers)"
docker image prune --force &>/dev/null
docker volume prune --force &>/dev/null

echo "removing docker containers"
docker_container=$(docker container list |grep bullsequana-edge-system-management_zabbix-server)
if [ ! -z "$docker_container" ]
then
  docker_container=$(echo $docker_container |awk '{ print $1; }')
  if [ ! -z "$docker_container" ]
  then
    docker container stop "$docker_container"
    docker container rm -f "$docker_container"
  fi
fi

docker_container=$(docker container list |grep bullsequana-edge-system-management_zabbix-agent)
if [ ! -z "$docker_container" ] 
then
  docker_container=$(echo $docker_container |awk '{ print $1; }')
  if [ ! -z "$docker_container" ] 
  then
    docker container stop "$docker_container"
    docker container rm -f "$docker_container"
  fi
fi
docker_container=$(docker container list |grep 'bullsequana-edge-system-management_zabbix-web')
if [ ! -z "$docker_container" ] 
then
  docker_container=$(echo $docker_container |awk '{ print $1; }')
  if [ ! -z "$docker_container" ] 
  then
    docker container stop "$docker_container"
    docker container rm -f "$docker_container"
  fi
fi
docker_container=$(docker container list |grep -m 1 'zabbix-postgres')
if [ ! -z "$docker_container" ] 
then
  docker_container=$(echo $docker_container |awk '{ print $1; }')
  if [ ! -z "$docker_container" ] 
  then
    docker container stop "$docker_container"
    docker container rm -f "$docker_container"
  fi
fi

echo "removing docker images"

docker_image=$(docker images |grep 'bullsequana-edge-system-management_zabbix-server')
if [ ! -z "$docker_image" ] 
then
  docker_image=$(echo $docker_image |awk '{ print $3; }')
  if [ ! -z "$docker_image" ] 
  then    
    docker image rmi -f  "$docker_image"
  fi
fi

docker_image=$(docker images |grep 'bullsequana-edge-system-management_zabbix-agent')
if [ ! -z "$docker_image" ] 
then
  docker_image=$(echo $docker_image |awk '{ print $3; }')
  if [ ! -z "$docker_image" ] 
  then    
    docker image rmi -f  "$docker_image"
  fi
fi

docker_image=$(docker images |grep 'bullsequana-edge-system-management_zabbix-web')
if [ ! -z "$docker_image" ] 
then
  docker_image=$(echo $docker_image |awk '{ print $3; }')
  if [ ! -z "$docker_image" ] 
  then    
    docker image rmi -f  "$docker_image"
  fi
fi

docker_image=$(docker images |grep 'postgres')
if [ ! -z "$docker_image" ] 
then
  docker_image=$(echo $docker_image |awk '{ print $3; }')
  if [ ! -z "$docker_image" ] 
  then    
    docker image rmi -f  "$docker_image"
  fi
fi

echo "docker containers and images removed"
