#!/bin/sh

echo "MISM_BULLSEQUANA_EDGE_VERSION environment variable is :"
docker exec -it awx_web env |grep MISM_BULLSEQUANA_EDGE_VERSION


