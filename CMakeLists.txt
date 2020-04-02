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

cmake_minimum_required(VERSION 3.12)  # use cmake 3.12 or later

project(nutools VERSION 3.06.01 LANGUAGES CXX)

set(fcl_dir job)
find_package(cetmodules)
include(CetCMakeEnv)
cet_cmake_env()

# -D_GLIBCXX_USE_NANOSLEEP is needed to make std::this_thread::sleep_for available. (IFDatabase)
cet_set_compiler_flags(DIAGS CAUTIOUS WERROR
                       NO_UNDEFINED
                       EXTRA_FLAGS -pedantic
                       EXTRA_CXX_FLAGS -D_GLIBCXX_USE_NANOSLEEP
                                       -Wno-unused-local-typedefs -Wno-variadic-macros)
cet_report_compiler_flags()

# these are minimum required versions, not the actual product versions
find_package( ROOT REQUIRED COMPONENTS MathCore Geom GeomPainter GX11 EG EGPythia6 Gui)
find_package( art REQUIRED)
find_package( art_root_io REQUIRED)
find_package( cetlib REQUIRED)
find_package( cetlib_except REQUIRED)
find_package( nusimdata REQUIRED )

# macros
include(ArtMake)
include(BuildPlugins)
include(CetRootCint)

# include search path
include_directories ( ${CRYHOME}/src )

# included for Mac OSX using XQuartz for X11
if(APPLE)
  include_directories ( /opt/X11/include )
endif()



## find_library directives
# other dependencies
cet_find_library( CRY NAMES CRY PATHS ENV CRY_LIB NO_DEFAULT_PATH )

# source
add_subdirectory (nutools)
#add_subdirectory (tools)
#add_subdirectory (test)
#add_subdirectory (bundle)
add_subdirectory(cmakeConfig)
# ups - table and config files
#add_subdirectory(ups)

# packaging utility
#include(UseCPack)

