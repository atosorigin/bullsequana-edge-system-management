#!/bin/sh

echo "adding playbooks ..."
docker exec -it awx_web projects/add_playbooks.py

