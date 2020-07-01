#!/bin/sh

. ./versions.sh

echo "updating restart=$always_or_no option BullSequana Edge Ansible AWX containers ...."

export docker_container=`docker container list |grep $MISM_BULLSEQUANA_EDGE_VERSION |grep 'awx_web' |awk '{ print $2; }'`
if [ ! -z "$docker_container" ] 
then
    echo "updating restart=$always_or_no option for awx_web container...."
    docker update --restart=$always_or_no awx_web
fi

export docker_container=`docker container list |grep $MISM_BULLSEQUANA_EDGE_VERSION |grep 'awx_task' |awk '{ print $2; }'`
if [ ! -z "$docker_container" ] 
then
    echo "updating restart=$always_or_no option for awx_task container...."
    docker update --restart=$always_or_no awx_task
fi

export docker_container=`docker container list |grep $MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION |grep 'awx_memcached' |awk '{ print $2; }'`
if [ ! -z "$docker_container" ] 
then
    echo "updating restart=$always_or_no option for awx_memcached container...."
    docker update --restart=$always_or_nono awx_memcached
fi

export docker_container=`docker container list |grep $RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION  |grep 'awx_rabbitmq' |awk '{ print $2; }'`
if [ ! -z "$docker_container" ] 
then
    echo "updating restart=$always_or_no option for awx_rabbitmq container...."
    docker update --restart=$always_or_no awx_rabbitmq
fi

export docker_container=`docker container list |grep $POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION |grep 'awx_postgres' |awk '{ print $2; }'`
if [ ! -z "$docker_container" ] 
then
    echo "updating restart=$always_or_no option for awx_postgres container...."
    docker update --restart=$always_or_no awx_postgres
fi

export docker_container=`docker container list |grep $PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION |grep 'pgadmin'`
if [ ! -z "$docker_container" ] 
then
    echo "updating restart=$always_or_no option for pgadmin container...."
    docker update --restart=$always_or_no pgadmin
fi

