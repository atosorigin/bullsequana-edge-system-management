#!/bin/sh

. ./versions.sh

echo "stopping BullSequana Edge Ansible AWX containers ...."
docker-compose -f docker_compose_awx.yml down

