#!/bin/bash

# at this point, we all branches are truncated and ready to push

get_this_dir() 
{
    ( cd / ; /bin/pwd -P ) >/dev/null 2>&1
    if (( $? == 0 )); then
      pwd_P_arg="-P"
    fi
    reldir=`dirname ${0}`
    thisdir=`cd ${reldir} && /bin/pwd ${pwd_P_arg}`
}


newdir=${1}
if [ -z ${newdir} ]; then
  echo "USAGE: $(basename ${0}) <new dir>"
  exit 1
fi
cd ${newdir} || exit 1

source /products/setup
setup git
type git

get_this_dir

echo "in ${PWD} at ${thisdir}"

dlist=`ls -1 ${thisdir}`
echo ${dlist}

for gdir in ${dlist}; do
    cd ${thisdir}/${gdir} || exit 1
    git remote add gh git@github.com:NuSoftHEP/${gdir}.git
    echo "push develop, master/main first"
    git checkout develop
    git push -u gh develop && git remote set-head -a gh 
    git checkout master
    git branch -M master main 
    git push -u gh main:main
    echo "finding branches in $gdir"
    blist=`git branch -a | grep remotes | grep -v HEAD | grep -v develp | grep -v master | grep -v main | sed -e 's%remotes/origin/%%'`
    for gbr in ${blist}; do
      git checkout ${gbr}
      echo "ready to push ${gdir} branch ${gbr} to github"
      git push -u gh ${gbr}:${gbr}
    done
    git push --tags gh
done


exit 0

