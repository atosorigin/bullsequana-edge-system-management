#!/bin/sh

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
docker exec -it awx_web projects/add_playbooks.py

echo -e "\033[32mif you get an error: check https://localhost/api/v2/ on the docker host and re-run this script\033[0m"

