#!/bin/bash

cd /var/mism

while true; do
    read -p "Enter tag ? [N n no to stop]" tag
    case $tag in
        [0-9.]* ) git tag -d $tag; git push origin :refs/tags/$tag; break;;
        [Nn]* ) break;;
        * ) echo "Please answer a tag or no.";;
    esac
done 

