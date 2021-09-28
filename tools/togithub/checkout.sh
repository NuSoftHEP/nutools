#!/bin/bash

# start testing the pieces needed to migrate the nutools suite to github

newdir=${1}
if [ -z ${newdir} ]; then
  echo "USAGE: $(basename ${0}) <new dir>"
  exit 1
fi
if [ -d ${newdir} ]; then
  echo "ERROR: ${newdir} already exists"
  exit 1
fi
mkdir -p ${newdir}
cd ${newdir} || exit 1

source /products/setup
setup git
type git

git clone ssh://p-nuevdb@cdcvs.fnal.gov/cvs/projects/nuevdb
git clone ssh://p-nug4@cdcvs.fnal.gov/cvs/projects/nug4
git clone ssh://p-nugen@cdcvs.fnal.gov/cvs/projects/nugen
git clone ssh://p-nurandom@cdcvs.fnal.gov/cvs/projects/nurandom
git clone ssh://p-nusimdata@cdcvs.fnal.gov/cvs/projects/nusimdata
git clone ssh://p-nutools@cdcvs.fnal.gov/cvs/projects/nutools

exit 0

