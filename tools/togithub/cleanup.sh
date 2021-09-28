#!/bin/bash

# start testing the pieces needed to migrate the nutools suite to github

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

#dlist="nuevdb  nug4  nugen  nurandom  nusimdata  nutools"
dlist=`ls -1 ${thisdir}`
echo ${dlist}

for gdir in ${dlist}; do
  if [[ ${gdir} == "nutools" ]]; then
    echo "will not cleanup $gdir"
  else
    cd ${thisdir}/${gdir} || exit 1
    git pull
    echo "finding branches in $gdir"
    blist=`git branch -a | grep remotes | grep -v HEAD | sed -e 's%remotes/origin/%%'`
    for gbr in ${blist}; do
      git checkout ${gbr}
      /home/garren/building/artutilscripts/tools/truncate-history.sh
    done
  fi
done


exit 0

