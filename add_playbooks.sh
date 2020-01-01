#!/bin/sh

echo "adding playbooks ..."
docker exec -it awx_web projects/add_playbooks.py

echo "if you get following errors"
echo "Failed to establish a new connection"
echo "Connection refused"
echo -e "\033[32mjust wait a while and re-run this script\033[0m"
echo "Check the API url that should be available: https://localhost/api/v2/"
