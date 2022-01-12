#!/bin/sh

echo "BullSequana Edge System Management Light version "
docker exec -it awx_web env |grep MISM_BULLSEQUANA_EDGE_VERSION
tail -1 ansible/readme.md
echo