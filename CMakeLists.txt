# ======================================================================
#  nutools main build file
#
#  cd .../path/to/build/directory
#  source .../path/to/nutools/ups/setup_for_development
#  cmake [-DCMAKE_INSTALL_PREFIX=/install/path]
#        -DCMAKE_BUILD_TYPE=$CETPKG_TYPE
#        $CETPKG_SOURCE
#
#  make
#  make test
#  make install
#  make package (builds distribution tarfile)
# ======================================================================

cmake_minimum_required(VERSION 3.18.2 FATAL_ERROR)

project(nutools LANGUAGES NONE)
add_subdirectory (bundle)
