#!/bin/sh

. ./versions.sh

echo "updating restart=$unless_stopped_or_no option BullSequana Edge Ansible AWX containers ...."

export docker_container=`docker container list |grep $MISM_BULLSEQUANA_EDGE_VERSION |grep 'zabbix-web' |awk '{ print $2; }'`
if [ ! -z "$docker_container" ] 
then
    echo "updating restart=$unless_stopped_or_no option for zabbix-web container...."
    docker update --restart=$unless_stopped_or_no zabbix-web
fi

export docker_container=`docker container list |grep $MISM_BULLSEQUANA_EDGE_VERSION |grep 'zabbix-server' |awk '{ print $2; }'`
if [ ! -z "$docker_container" ] 
then
    echo "updating restart=$unless_stopped_or_no option for zabbix-server container...."
    docker update --restart=$unless_stopped_or_no zabbix-server
fi

export docker_container=`docker container list |grep $MISM_BULLSEQUANA_EDGE_VERSION |grep 'zabbix-agent' |awk '{ print $2; }'`
if [ ! -z "$docker_container" ] 
then
    echo "updating restart=$unless_stopped_or_no option for zabbix-agent container...."
    docker update --restart=$unless_stopped_or_no zabbix-agent
fi

export docker_container=`docker container list |grep $POSTGRES_ZABBIX_BULLSEQUANA_EDGE_VERSION |grep 'zabbix-postgres' |awk '{ print $2; }'`
if [ ! -z "$docker_container" ] 
then
    echo "updating restart=$unless_stopped_or_no option for zabbix-postgres container...."
    docker update --restart=$unless_stopped_or_no zabbix-postgres
fi

