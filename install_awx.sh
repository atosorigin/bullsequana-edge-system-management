#!/bin/sh

echo "starting BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker-compose-awx.yml up -d

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "now wait 10 minutes for the migration to complete...."
echo "check the login page at https://localhost"
echo "and run ./add_playbooks.sh"
echo "AWX is available on https://localhost"
echo "pgadmin is available on http://localhost:7070"
echo "for more info, refer to documentation"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"



