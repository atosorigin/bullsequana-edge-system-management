#!/bin/sh

echo "MISM_VERSION environment variable is :"
docker exec -it awx_web env |grep MISM_VERSION


