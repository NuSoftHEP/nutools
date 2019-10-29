#!/bin/bash

#  BEFORE YOU RUN THIS SCRIPT:
#  git clone ssh://p-nutools@cdcvs.fnal.gov/cvs/projects/nutools nuevdb
#  cd nuevdb
#  git remote remove origin
#  use git mv and git rm
#     nutools becomes nuevdb
#     nuevdb contains EventDisplayBase and IFDatabase
#  edit CMakeLists.txt and nuevdb/CMakeLists.txt
#  run UseNuevdb.sh
#  git commit

#  AFTER EVERYTHING IS WORKING
# git remote add origin ssh://p-nuevdb@cdcvs.fnal.gov/cvs/projects/nuevdb
# git remote -v
# git push -u origin develop
# git push -u origin nova_v1_00_br

# use git-delete-history.sh

cd /home/garren/devel/nu/nuevdb
/home/garren/devel/nu/nutools/tools/nutools3/creation/git-delete-history.sh \
  test \
  tools \
  nutools/EventGeneratorBase \
  nutools/G4Base \
  nutools/G4NuPhysicsLists \
  nutools/MagneticField \
  nutools/NuBeamWeights \
  nutools/NuReweight \
  nutools/ParticleNavigation \
  nutools/RandomUtils

git repack -A
git gc --aggressive

# now rename
##git mv nutools nugen

exit 0

