#!/bin/sh

export MISM_BULLSEQUANA_EDGE_PLAYBOOKS_VERSION=2.1.6

###################################################################################################################
# passwords.yml
###################################################################################################################
pwd=$(pwd)
export ANSIBLE_PASSWORDS=$pwd/ansible/vars/passwords.yml

if [ ! -f $ANSIBLE_PASSWORDS ] 
then
  touch $ANSIBLE_PASSWORDS
  echo -e "\033[32m$ANSIBLE_PASSWORDS was successfully created\033[0m"
fi

###################################################################################################################
# playbooks
###################################################################################################################
echo "adding playbooks ..."
docker exec -e MISM_BULLSEQUANA_EDGE_PLAYBOOKS_VERSION=$MISM_BULLSEQUANA_EDGE_PLAYBOOKS_VERSION -it awx_web projects/add_playbooks.py

echo -e "\033[32mif you get an error: check https://localhost/api/v2/ and re-run this script\033[0m"
