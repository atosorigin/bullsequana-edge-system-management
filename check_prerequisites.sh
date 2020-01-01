#!/bin/sh

echo "checking docker prerequisite"
docker_state=$(systemctl show --property ActiveState docker|grep active)
if [ -z  "$docker_state" ] 
then
  echo -e "\033[31mdocker is NOT active\033[0m"
  exit -1
fi

echo "checking docker version prerequisite"
docker_compose_version=$(docker-compose --version|grep version)
if [ -z "$docker_compose_version" ]
then
  echo -e "\033[31mdocker-compose is NOT installed\033[0m"
  exit -1
fi

