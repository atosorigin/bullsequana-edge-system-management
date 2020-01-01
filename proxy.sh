#!/bin/sh

# Copy proxy to .env files for use in docker_compose files
#     env_file:
#       - Dockerfiles/ansible.env  
ansible_file=Dockerfiles/ansible.env
zabbix_file=Dockerfiles/zabbix.env

grep -q NO_PROXY= $ansible_file && sed -i.bak '/NO_PROXY=.*/d' $ansible_file
grep -q NO_PROXY= $zabbix_file && sed -i.bak '/NO_PROXY=.*/d' $zabbix_file
if [ -v NO_PROXY ]
then
  echo "NO_PROXY=$NO_PROXY" >> $ansible_file
  echo "NO_PROXY=$NO_PROXY" >> $zabbix_file
  echo "NO_PROXY="$NO_PROXY
else
  echo "NO_PROXY environment variable not found"
fi

grep -q HTTP_PROXY= $ansible_file && sed -i.bak '/HTTP_PROXY=.*/d' $ansible_file
grep -q HTTP_PROXY= $zabbix_file && sed -i.bak '/HTTP_PROXY=.*/d' $zabbix_file
grep -q http_proxy= $ansible_file && sed -i.bak '/http_proxy=.*/d' $ansible_file
grep -q http_proxy= $zabbix_file && sed -i.bak '/http_proxy=.*/d' $zabbix_file
if [ -v HTTP_PROXY ]
then
  echo "HTTP_PROXY=$HTTP_PROXY" >> $ansible_file
  echo "HTTP_PROXY=$HTTP_PROXY" >> $zabbix_file
  echo "http_proxy=$HTTP_PROXY" >> $ansible_file
  echo "http_proxy=$HTTP_PROXY" >> $zabbix_file
  echo "HTTP_PROXY="$HTTP_PROXY
else
  echo "HTTP_PROXY environment variable not found"
fi

grep -q HTTPS_PROXY= $ansible_file && sed -i.bak '/HTTPS_PROXY=.*/d' $ansible_file
grep -q HTTPS_PROXY= $zabbix_file && sed -i.bak '/HTTPS_PROXY=.*/d' $zabbix_file
grep -q https_proxy= $ansible_file && sed -i.bak '/https_proxy=.*/d' $ansible_file
grep -q https_proxy= $zabbix_file && sed -i.bak '/https_proxy=.*/d' $zabbix_file
if [ -v HTTPS_PROXY ]
then
  echo "HTTPS_PROXY=$HTTPS_PROXY" >> $ansible_file
  echo "HTTPS_PROXY=$HTTPS_PROXY" >> $zabbix_file
  echo "https_proxy=$HTTPS_PROXY" >> $ansible_file
  echo "https_proxy=$HTTPS_PROXY" >> $zabbix_file
  echo "HTTPS_PROXY="$HTTPS_PROXY
else
  echo "HTTPS_PROXY environment variable not found"
fi

