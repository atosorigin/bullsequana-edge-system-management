#!/bin/sh

unset $mism_version 
echo Enter new version?
read mism_version

export MISM_BULLSEQUANA_EDGE_VERSION=$mism_version
export MISM_TAG_BULLSEQUANA_EDGE_VERSION=tag
export AWX_BULLSEQUANA_EDGE_VERSION=9.0.1
export RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION=3.8.1-management
export POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION=12.0-alpine
export PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION=4.14
export MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION=1.5.20-alpine

export ZABBIX_BULLSEQUANA_EDGE_VERSION=centos-4.4.1
export POSTGRES_ZABBIX_BULLSEQUANA_EDGE_VERSION=12.0-alpine

echo "git add all"

git add . --all
git commit -m "deliverable $MISM_BULLSEQUANA_EDGE_VERSION"
git push

echo "delete old generation"
# delete local tag
git tag -d $MISM_BULLSEQUANA_EDGE_VERSION
# delete remote tag (eg, GitHub version too)
git push origin :refs/tags/$MISM_BULLSEQUANA_EDGE_VERSION

rm -rf /var/livraisons/$MISM_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management
mkdir /var/livraisons/$MISM_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management
cd /var/livraisons/$MISM_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management

echo "git clone atos"
git clone https://github.com/atosorigin/bullsequana-edge-system-management.git

cd bullsequana-edge-system-management

echo "git tag $MISM_BULLSEQUANA_EDGE_VERSION"
git tag $MISM_BULLSEQUANA_EDGE_VERSION
git push origin master --tags
git checkout $MISM_BULLSEQUANA_EDGE_VERSION

echo "wait for $MISM_BULLSEQUANA_EDGE_VERSION to be generated on docker atos site and run 2..."

