#!/bin/sh

export HTTP_PROXY=$HTTP_PROXY
export HTTPS_PROXY=$HTTPS_PROXY

echo "cloning BullSequana Edge Ansible AWX containers ...."
git clone "https://www.github.com/frsauvage/MISM.git"
echo "starting BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker-compose-awx-from-dockerhub.yml up -d

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "now wait 10 minutes for the migration to complete...."
echo "check the login page at https://localhost"
echo "and run ./add_playbooks.sh"
echo "AWX is available on https://localhost"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to documentation"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"



