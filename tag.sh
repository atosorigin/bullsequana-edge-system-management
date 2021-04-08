#!/bin/sh

echo --------------------------------------
echo -- Tagging on Github refs/tag/$VERSION
echo --------------------------------------
git config user.email francine.sauvage@atos.net
git config user.name frsauvage
git add . --all
git commit -m "deliverable $VERSION"
git push

git_cmd="git ls-remote --tags origin refs/tags/$VERSION | egrep --only-matching refs/tags/.*"
eval_git_tag=$(eval "$git_cmd")
echo $eval_git_tag

if [ ! -z "$eval_git_tag" ] 
then
   git tag -d $VERSION
   git push origin :refs/tags/$VERSION
   echo "old tag $VERSION deleted on github" 
fi

eval_git_tag=$(eval "$git_cmd")
echo $eval_git_tag
if [ ! -z "$eval_git_tag" ] 
then
  echo -e "\e[101mTag $VERSION always on github => remove it manually and re-run this script !!!!!!\e[0m" 
  exit -1
fi

git tag $VERSION
git push origin --tags
