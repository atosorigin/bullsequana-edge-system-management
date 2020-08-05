#!/bin/sh

unset $mism_version 

CWD="$(pwd)"
PKG=$CWD/pkg

echo ---------------------------------------------
echo -- You should build a version over jenkins --
echo ---------------------------------------------

read -p "Enter  new version ? " mism_version

git tag -d $mism_version
git push --delete origin $mism_version

echo "export MISM_BULLSEQUANA_EDGE_VERSION=${mism_version}" > versions.sh
echo "export MISM_TAG_BULLSEQUANA_EDGE_VERSION=tag" >> versions.sh
echo "export AWX_BULLSEQUANA_EDGE_VERSION=9.0.1" >> versions.sh
echo "export RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION=3.8.1-management" >> versions.sh
echo "export POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION=12.0-alpine" >> versions.sh
echo "export PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION=4.14" >> versions.sh
echo "export MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION=1.5.20-alpine" >> versions.sh
echo "export ZABBIX_BULLSEQUANA_EDGE_VERSION=centos-4.4.1" >> versions.sh
echo "export POSTGRES_ZABBIX_BULLSEQUANA_EDGE_VERSION=12.0-alpine" >> versions.sh

#echo "export AWX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
#echo "export RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
#echo "export POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
#echo "export PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
#echo "export MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
#echo "export ZABBIX_BULLSEQUANA_EDGE_VERSION=centos-latest" >> versions.sh
#echo "export POSTGRES_ZABBIX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh

. ./versions.sh

sed -i "s/MISM_BULLSEQUANA_EDGE_VERSION=.*/MISM_BULLSEQUANA_EDGE_VERSION=${mism_version}/" Dockerfiles/Dockerfile-awx_web.tag
sed -i "s/MISM_BULLSEQUANA_EDGE_VERSION=.*/MISM_BULLSEQUANA_EDGE_VERSION=${mism_version}/" Dockerfiles/Dockerfile-awx_task.tag
sed -i "s/MISM_BULLSEQUANA_EDGE_VERSION=.*/MISM_BULLSEQUANA_EDGE_VERSION=${mism_version}/" Dockerfiles/Dockerfile-zabbix.tag
sed -i "s/MISM_BULLSEQUANA_EDGE_VERSION=.*/MISM_BULLSEQUANA_EDGE_VERSION=${mism_version}/" Dockerfiles/Dockerfile-zabbix-web.tag
sed -i "s/MISM_BULLSEQUANA_EDGE_VERSION=.*/MISM_BULLSEQUANA_EDGE_VERSION=${mism_version}/" Dockerfiles/Dockerfile-zabbix-agent.tag

git tag $mism_version
git push origin master --tags

echo current Branch is 
git branch
echo parameter is ${MISM_BULLSEQUANA_EDGE_VERSION}

git commit -am "deliverable ${mism_version}"
git push
git push origin master --tags

docker container stop $(docker container ls -aq)
docker container rm $(docker container ls -aq)
docker image rmi $(docker image ls -aq)

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
rm -rf ansible/playbooks/redfish
rm -rf ansible/vars/external_vars.yml
rm -rf ansible/vars/passwords.yml
rm -rf pkg/mism*
rm -rf *readme.*
rm -rf test*
rm -rf *.bak
rm install_ansible_prequisites.sh
rm -f zabbix/server/externalscripts/openbmc/*

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
#docker-compose -f docker_compose_awx.yml build
#docker-compose -f docker_compose_zabbix.yml build
docker-compose -f docker_compose_awx.yml pull --ignore-pull-failures
#docker-compose -f docker_compose_awx.yml pull
docker-compose -f docker_compose_zabbix.yml pull --ignore-pull-failures
#docker-compose -f docker_compose_zabbix.yml pull

echo "docker save tag $MISM_BULLSEQUANA_EDGE_VERSION"

docker save -o bullsequana-edge-system-management_zabbix-web.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-web:$MISM_BULLSEQUANA_EDGE_VERSION
if [ ! -f bullsequana-edge-system-management_zabbix-web.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "bullsequana-edge-system-management_zabbix-web.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o bullsequana-edge-system-management_zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-agent:$MISM_BULLSEQUANA_EDGE_VERSION
if [ ! -f bullsequana-edge-system-management_zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "bullsequana-edge-system-management_zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o bullsequana-edge-system-management_zabbix-server.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_zabbix-server:$MISM_BULLSEQUANA_EDGE_VERSION
if [ ! -f bullsequana-edge-system-management_zabbix-server.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "bullsequana-edge-system-management_zabbix-server.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o bullsequana-edge-system-management_awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_awx_task:$MISM_BULLSEQUANA_EDGE_VERSION
if [ ! -f bullsequana-edge-system-management_awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "bullsequana-edge-system-management_awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o bullsequana-edge-system-management_awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar bullsequana-edge-system-management_awx_web:$MISM_BULLSEQUANA_EDGE_VERSION
if [ ! -f bullsequana-edge-system-management_awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "bullsequana-edge-system-management_awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o rabbitmq.$MISM_BULLSEQUANA_EDGE_VERSION.tar rabbitmq:$RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION
if [ ! -f rabbitmq.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "rabbitmq.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o memcached.$MISM_BULLSEQUANA_EDGE_VERSION.tar memcached:$MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION
if [ ! -f memcached.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "memcached.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar ansible/awx_task:$AWX_BULLSEQUANA_EDGE_VERSION
if [ ! -f awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "awx_task.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar ansible/awx_web:$AWX_BULLSEQUANA_EDGE_VERSION
if [ ! -f awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "awx_web.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o zabbix-server-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar zabbix/zabbix-server-pgsql:$ZABBIX_BULLSEQUANA_EDGE_VERSION
if [ ! -f zabbix-server-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "zabbix-server-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o zabbix-web-nginx-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar zabbix/zabbix-web-nginx-pgsql:$ZABBIX_BULLSEQUANA_EDGE_VERSION
if [ ! -f zabbix-web-nginx-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "zabbix-web-nginx-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar zabbix/zabbix-agent:$ZABBIX_BULLSEQUANA_EDGE_VERSION
if [ ! -f zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o postgres.$MISM_BULLSEQUANA_EDGE_VERSION.tar postgres:$POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION
if [ ! -f postgres.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "postgres.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

docker save -o pgadmin4.$MISM_BULLSEQUANA_EDGE_VERSION.tar dpage/pgadmin4:$PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION
if [ ! -f pgadmin4.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]; then
    echo "pgadmin4.$MISM_BULLSEQUANA_EDGE_VERSION.tar file not found!"
    exit -1
fi

count_tar=$(ls -l . | egrep -c '*.tar$')

if [ ! "$count_tar" -eq 14 ]
then
  echo -e "\033[31mError: bad tar count: $count_tar / 14 !!\033[0m"
  exit -1
fi

rm -rf ansible/pgdata
rm -rf zabbix/pgdata
rm -rf ansible/vars/passwords.yml
rm -rf ansible/vars/external_vars.yml

rm -f mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz

echo "docker tar $MISM_BULLSEQUANA_EDGE_VERSION"
tar -czvf mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz *
echo "terminated : docker mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz file generated in /var/livraisons/$MISM_BULLSEQUANA_EDGE_VERSION-bullsequana-edge-system-management/bullsequana-edge-system-management"

echo "checking pgdata passwords.yml external_vars.yml in tar"
check_should_not_exists=`tar -tvf mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz |grep -E 'pgdata|passwords.yml|external_vars.yml'`
if [ ! -z "$check_should_not_exists" ]
then
  echo -e "\033[31mError: pgdata or passwords.jyml or external_vars.yml exists !! \033[0m"
  rm -rf mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz
fi

echo -e "\033[32mCount tar ok : $count_tar / 14\033[0m"

mv mism.$MISM_BULLSEQUANA_EDGE_VERSION.tar.gz $PKG

cd $CWD

git checkout master

echo "export MISM_BULLSEQUANA_EDGE_VERSION=latest" > versions.sh
echo "export MISM_TAG_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
echo "export AWX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
echo "export RABBITMQ_AWX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
echo "export POSTGRES_AWX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
echo "export PGADMIN_AWX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
echo "export MEMCACHED_AWX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
echo "export ZABBIX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh
echo "export POSTGRES_ZABBIX_BULLSEQUANA_EDGE_VERSION=latest" >> versions.sh

git commit -am "back to latest"
git push

