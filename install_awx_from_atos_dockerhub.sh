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

attempt_num=1
max_attempts=5

export add_playbooks=`./add_playbooks.sh`

while timeout -k 70 60 $add_playbooks; [ $? = 124 ]
do 
  if ((attempt_num==max_attempts))
  then
    echo "Attempt $attempt_num failed and there are no more attempts left!"
    return 1
  fi
  echo "waiting $attempt_num minutes"
  sleep $((attempt_num++))*60  # Pause before retry (growing time...)
 
done

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "AWX is available on https://localhost"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to github site https://github.com/atosorigin/bullsequana-edge-system-management ansible part"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"



