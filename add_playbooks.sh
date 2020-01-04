#!/bin/sh

echo "adding playbooks ..."
docker exec -it awx_web projects/add_playbooks.py

echo -e "\033[32mif you get an error: check https://localhost/api/v2/ on the docker host and re-run this script\033[0m"

