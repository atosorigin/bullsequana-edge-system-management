#!/bin/sh

export old_mism_version=$MISM_BULLSEQUANA_EDGE_VERSION

. ./check_prerequisites.sh
# comment the next line if you build from your own Dockerfiles with build_zabbix.sh
. ./remove_zabbix_containers.sh

if [ ! -z $MISM_BULLSEQUANA_EDGE_VERSION ]
then
  if [ ! -z $old_mism_version ]
  then
    if [ $old_mism_version != $MISM_BULLSEQUANA_EDGE_VERSION  ]
    then
      rm -f bullsequana-edge-system-management_zabbix-web.$old_mism_version.tar
      rm -f bullsequana-edge-system-management_zabbix-web.$old_mism_version.tar
      rm -f bullsequana-edge-system-management_zabbix-agent.$old_mism_version.tar 
      rm -f zabbix-server-pgsql.$old_mism_version.tar
      rm -f zabbix-web-nginx-pgsql.$old_mism_version.tar
      rm -f zabbix-agent.$old_mism_version.tar
      rm -f postgres.$old_mism_version.tar
    fi
  fi
fi

chmod ugo+w zabbix/server/externalscripts/openbmc

set -euo pipefail

if filename=$(readlink /etc/localtime); then
    # /etc/localtime is a symlink as expected
    export timezone=${filename#*zoneinfo/}
    if [[ $timezone = "$filename" || ! $timezone =~ ^[^/]+/[^/]+$ ]]; then
        # not pointing to expected location or not Region/City
        >&2 echo "$filename points to an unexpected location"
        exit 1
    fi
else  # compare files by contents
    # https://stackoverflow.com/questions/12521114/getting-the-canonical-time-zone-name-in-shell-script#comment88637393_12523283
     export timezone=$(find /usr/share/zoneinfo -type f ! -regex ".*/Etc/.*" -exec cmp -s {} /etc/localtime \; -print | sed -e 's@.*/zoneinfo/@@' | head -n1)
fi

echo $timezone

. ./proxy.sh
. ./versions.sh

export docker_image=`docker images |grep $MISM_BULLSEQUANA_EDGE_VERSION |grep 'bullsequana-edge-system-management_zabbix-web' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f bullsequana-edge-system-management_zabbix-web.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading Bull Zabbix web image ...."
    docker load --input bullsequana-edge-system-management_zabbix-web.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep $MISM_BULLSEQUANA_EDGE_VERSION |grep 'bullsequana-edge-system-management_zabbix-server' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f bullsequana-edge-system-management_zabbix-server.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading Bull Zabbix server image ...."
    docker load --input bullsequana-edge-system-management_zabbix-server.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep $MISM_BULLSEQUANA_EDGE_VERSION |grep 'bullsequana-edge-system-management_zabbix-agent' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f bullsequana-edge-system-management_zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading Bull Zabbix task image ...."
    docker load --input bullsequana-edge-system-management_zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep $ZABBIX_BULLSEQUANA_EDGE_VERSION |grep 'zabbix-server-pgsql' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f zabbix-server-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading Zabbix server pgsql image ...."
    docker load --input zabbix-server-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep $ZABBIX_BULLSEQUANA_EDGE_VERSION |grep 'zabbix-web-nginx-pgsql' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f zabbix-web-nginx-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading Zabbix web nginx image ...."
    docker load --input zabbix-web-nginx-pgsql.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep $ZABBIX_BULLSEQUANA_EDGE_VERSION |grep 'zabbix-agent' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading Zabbix agent  image ...."
    docker load --input zabbix-agent.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

export docker_image=`docker images |grep $POSTGRES_ZABBIX_BULLSEQUANA_EDGE_VERSION |grep 'postgres' |awk '{ print $3; }'`
if [ -z "$docker_image" ] 
then
  if [ -f postgres.$MISM_BULLSEQUANA_EDGE_VERSION.tar ]
  then
    echo "loading postgres $MISM_BULLSEQUANA_EDGE_VERSION image ...."
    docker load --input postgres.$MISM_BULLSEQUANA_EDGE_VERSION.tar
  fi
fi

echo "starting BullSequana Edge Zabbix containers ...."
docker-compose -f docker_compose_zabbix.yml up -d

echo "---------------------------------------------------------------------------------------------------"
echo -e " \e[5mWarning: Port"
echo -e "Zabbix is available on \e[101mhttps://localhost:8443"
echo "for more info, refer to github site https://github.com/atosorigin/bullsequana-edge-system-management"
echo "----------------------------------------------------------------------------------------------------"



