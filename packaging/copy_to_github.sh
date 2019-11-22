#!/bin/sh


cd /var/bullsequana-edge-system-management/

cp -r /var/mism/* .
cp /var/mism/.gitignore .
rm -rf /var/bullsequana-edge-system-management/cli

git add . --all
git commit -m "synchro with bitbucket $MISM_BULLSEQUANA_EDGE_VERSION"
git push

echo "delete old generation"
# delete local tag
git tag -d $MISM_BULLSEQUANA_EDGE_VERSION
# delete remote tag (eg, GitHub version too)
git push origin :refs/tags/$MISM_BULLSEQUANA_EDGE_VERSION

git tag $MISM_BULLSEQUANA_EDGE_VERSION
git push origin master --tags
