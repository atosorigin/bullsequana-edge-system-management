#!/bin/sh

sed -i "s/export MISM_BULLSEQUANA_EDGE_PLAYBOOKS_VERSION=.*/export MISM_BULLSEQUANA_EDGE_PLAYBOOKS_VERSION=${VERSION}/" add_awx_playbooks.sh
# MISM_BULLSEQUANA_EDGE_VERSION
sed -i "s/MISM_BULLSEQUANA_EDGE_VERSION=.*/MISM_BULLSEQUANA_EDGE_VERSION=${MISM_BULLSEQUANA_EDGE_VERSION}/" Dockerfiles/Dockerfile-awx_web
sed -i "s/MISM_BULLSEQUANA_EDGE_VERSION=.*/MISM_BULLSEQUANA_EDGE_VERSION=${MISM_BULLSEQUANA_EDGE_VERSION}/" Dockerfiles/Dockerfile-awx_task
sed -i "s/MISM_BULLSEQUANA_EDGE_VERSION=.*/MISM_BULLSEQUANA_EDGE_VERSION=${MISM_BULLSEQUANA_EDGE_VERSION}/" Dockerfiles/Dockerfile-zabbix
sed -i "s/MISM_BULLSEQUANA_EDGE_VERSION=.*/MISM_BULLSEQUANA_EDGE_VERSION=${MISM_BULLSEQUANA_EDGE_VERSION}/" Dockerfiles/Dockerfile-zabbix-web
sed -i "s/MISM_BULLSEQUANA_EDGE_VERSION=.*/MISM_BULLSEQUANA_EDGE_VERSION=${MISM_BULLSEQUANA_EDGE_VERSION}/" Dockerfiles/Dockerfile-zabbix-agent

# ARG REGISTRY
export REGISTRY=ansible
sed -i "s/ARG REGISTRY.*/ARG REGISTRY=${REGISTRY}/" Dockerfiles/Dockerfile-awx_web
sed -i "s/ARG REGISTRY.*/ARG REGISTRY=${REGISTRY}/" Dockerfiles/Dockerfile-awx_task
export REGISTRY=zabbix
sed -i "s/ARG REGISTRY.*/ARG REGISTRY=${REGISTRY}/" Dockerfiles/Dockerfile-zabbix
sed -i "s/ARG REGISTRY.*/ARG REGISTRY=${REGISTRY}/" Dockerfiles/Dockerfile-zabbix-web
sed -i "s/ARG REGISTRY.*/ARG REGISTRY=${REGISTRY}/" Dockerfiles/Dockerfile-zabbix-agent

# ARG BASE_IMAGE_ZABBIX
sed -i "s/ARG BASE_IMAGE_AWX_WEB.*/ARG BASE_IMAGE_AWX_WEB=${BASE_IMAGE_AWX_WEB}/" Dockerfiles/Dockerfile-awx_web
sed -i "s/ARG BASE_IMAGE_AWX_TASK.*/ARG BASE_IMAGE_AWX_TASK=${BASE_IMAGE_AWX_TASK}/" Dockerfiles/Dockerfile-awx_task
sed -i "s/ARG BASE_IMAGE_ZABBIX.*/ARG BASE_IMAGE_ZABBIX=${BASE_IMAGE_ZABBIX}/" Dockerfiles/Dockerfile-zabbix
sed -i "s/ARG BASE_IMAGE_ZABBIX_WEB.*/ARG BASE_IMAGE_ZABBIX_WEB=${BASE_IMAGE_ZABBIX_WEB}/" Dockerfiles/Dockerfile-zabbix-web
sed -i "s/ARG BASE_IMAGE_ZABBIX_AGENT.*/ARG BASE_IMAGE_ZABBIX_AGENT=${BASE_IMAGE_ZABBIX_AGENT}/" Dockerfiles/Dockerfile-zabbix-agent

# ARG TAG_ZABBIX
sed -i "s/ARG TAG_AWX.*/ARG TAG_AWX=${AWX_BULLSEQUANA_EDGE_VERSION}/" Dockerfiles/Dockerfile-awx_web
sed -i "s/ARG TAG_AWX.*/ARG TAG_AWX=${AWX_BULLSEQUANA_EDGE_VERSION}/" Dockerfiles/Dockerfile-awx_task
sed -i "s/ARG TAG_ZABBIX.*/ARG TAG_ZABBIX=${ZABBIX_BULLSEQUANA_EDGE_VERSION}/" Dockerfiles/Dockerfile-zabbix
sed -i "s/ARG TAG_ZABBIX.*/ARG TAG_ZABBIX=${ZABBIX_BULLSEQUANA_EDGE_VERSION}/" Dockerfiles/Dockerfile-zabbix-web
sed -i "s/ARG TAG_ZABBIX.*/ARG TAG_ZABBIX=${ZABBIX_BULLSEQUANA_EDGE_VERSION}/" Dockerfiles/Dockerfile-zabbix-agent
