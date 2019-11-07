#!/bin/sh

echo "stopping BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker-compose-awx-from-dockerhub.yml down

