#!/bin/sh

unset $mism_version 

echo ------------------------------------------
echo 1. You should edit Dockerfile .tag files
echo 2. You should build a version over jenkins
echo ------------------------------------------

read -p "Enter jenkins new version ? " mism_version

git fetch && git fetch --tags
git checkout $mism_version

cd /var/livraisons/
rm -rf $mism_version-bullsequana-edge-system-management 
mkdir $mism_version-bullsequana-edge-system-management
cd $mism_version-bullsequana-edge-system-management

echo "git clone atos"
git clone https://github.com/atosorigin/bullsequana-edge-system-management.git

cd bullsequana-edge-system-management

echo "copy mism to livraison $mism_version"
cp -rf /var/mism/* .
cp /var/mism/.gitignore .
rm -rf cli
rm -rf ansible/pgdata
rm -rf zabbix/pgdata

chmod ugo+x versions.sh
. ./versions.sh

echo "changing to MISM version"
if [ -v MISM_BULLSEQUANA_EDGE_VERSION ]
then
  dockerfile="Dockerfiles/Dockerfile-awx_web.tag"
  sed -i 's|$MISM_BULLSEQUANA_EDGE_VERSION|'$MISM_BULLSEQUANA_EDGE_VERSION'|g' $dockerfile
  dockerfile="Dockerfiles/Dockerfile-awx_task.tag"
  sed -i 's|$MISM_BULLSEQUANA_EDGE_VERSION|'$MISM_BULLSEQUANA_EDGE_VERSION'|g' $dockerfile
  dockerfile="Dockerfiles/Dockerfile-zabbix.tag"
  sed -i 's|$MISM_BULLSEQUANA_EDGE_VERSION|'$MISM_BULLSEQUANA_EDGE_VERSION'|g' $dockerfile
  dockerfile="Dockerfiles/Dockerfile-zabbix-web.tag"
  sed -i 's|$MISM_BULLSEQUANA_EDGE_VERSION|'$MISM_BULLSEQUANA_EDGE_VERSION'|g' $dockerfile
  dockerfile="Dockerfiles/Dockerfile-zabbix-agent.tag"
  sed -i 's|$MISM_BULLSEQUANA_EDGE_VERSION|'$MISM_BULLSEQUANA_EDGE_VERSION'|g' $dockerfile
  dockerfile="Dockerfiles/loginModal.partial.html"
  sed -i 's|$MISM_BULLSEQUANA_EDGE_VERSION|'$MISM_BULLSEQUANA_EDGE_VERSION'|g' $dockerfile
MISM_BULLSEQUANA_EDGE_VERSION
fi

echo "git add/commit/push to github"
git add . --all
git commit -m "synchro with bitbucket $MISM_BULLSEQUANA_EDGE_VERSION"
git push

echo "delete old generation"
# delete local tag
git tag -d $MISM_BULLSEQUANA_EDGE_VERSION
# delete remote tag (eg, GitHub version too)
git push origin :refs/tags/$MISM_BULLSEQUANA_EDGE_VERSION

echo "git tag $MISM_BULLSEQUANA_EDGE_VERSION"
git tag $MISM_BULLSEQUANA_EDGE_VERSION
git push origin master --tags
git checkout $MISM_BULLSEQUANA_EDGE_VERSION

echo "building images tag $MISM_BULLSEQUANA_EDGE_VERSION"
docker-compose -f docker_compose_awx.yml build --no-cache
docker-compose -f docker_compose_zabbix.yml build --no-cache
docker-compose -f docker_compose_awx.yml pull --ignore-pull-failures
docker-compose -f docker_compose_zabbix.yml pull --ignore-pull-failures

echo "docker save tag $MISM_BULLSEQUANA_EDGE_VERSION"
docker save -o bullsequana-edge-system-management_zabbix-web.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-web:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o bullsequana-edge-system-management_zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-agent:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o bullsequana-edge-system-management_zabbix-server.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-server:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o bullsequana-edge-system-management_awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_awx_task:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o bullsequana-edge-system-management_awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_awx_web:$MISM_BULLSEQUANA_EDGE_VERSION
docker save -o rabbitmq.$MISM_BULLSEQUANA_EDGE_VERSION.tar rabbitmq:$RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION
docker save -o memcached.$MISM_BULLSEQUANA_EDGE_VERSION.tar memcached:$MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION
#docker save -o awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar ansible/awx_task:$AWX_BULLSEQUANA_EDGE_VERSION
#docker save -o awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar ansible/awx_web:$AWX_BULLSEQUANA_EDGE_VERSION
#docker save -o zabbix-server-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar zabbix/zabbix-server-pgsql:$ZABBIX_BULLSEQUANA_EDGE_VERSION
#docker save -o zabbix-web-nginx-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar zabbix/zabbix-web-nginx-pgsql:$ZABBIX_BULLSEQUANA_EDGE_VERSION
#docker save -o zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar zabbix/zabbix-agent:$ZABBIX_BULLSEQUANA_EDGE_VERSION
docker save -o postgres.$MISM_BULLSEQUANA_EDGE_VERSION.tar postgres:$POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION
docker save -o pgadmin4.$MISM_BULLSEQUANA_EDGE_VERSION.tar dpage/pgadmin4:$PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION

rm -rf ansible/pgdata
rm -rf zabbix/pgdata
rm -f mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz

echo "docker tar $MISM_BULLSEQUANA_EDGE_VERSION"
tar -czvf mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz *
echo "terminated : docker mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz file generated in /var/livraisons/$MISM_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management/bullsequana-edge-system-management"

cd /var/mism
git checkout master
