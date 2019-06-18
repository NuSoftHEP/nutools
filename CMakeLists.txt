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


# use cmake 2.8 or later
cmake_minimum_required (VERSION 3.11)

project(nutools VERSION 2.28.00 LANGUAGES CXX)
set(fcl_dir job)
find_package(cetmodules)
include(CetCMakeEnv)
cet_cmake_env()

# -D_GLIBCXX_USE_NANOSLEEP is needed to make std::this_thread::sleep_for available.
cet_set_compiler_flags(DIAGS CAUTIOUS WERROR
                       NO_UNDEFINED
                       EXTRA_FLAGS -pedantic
                       EXTRA_CXX_FLAGS -D_GLIBCXX_USE_NANOSLEEP
                                       -Wno-unused-local-typedefs -Wno-variadic-macros)
cet_report_compiler_flags()

# these are minimum required versions, not the actual product versions
find_package( PostgreSQL REQUIRED)
find_package( CLHEP REQUIRED )
find_package( Geant4 REQUIRED COMPONENTS ui_all vis_all )
find_package( Boost REQUIRED COMPONENTS filesystem system date_time thread regex)
find_package( ROOT REQUIRED COMPONENTS MathCore Geom GeomPainter GX11 EG EGPythia6 Gui)
find_package( art_root_io REQUIRED)
find_package( nusimdata REQUIRED )

## find_library directives
# other dependencies
cet_find_library(PYTHIA6 Pythia6 NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH)
cet_find_library(LHAPDF LHAPDF NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH)
cet_find_library(LOG4CPP log4cpp NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH)
cet_find_library(XML2 xml2 NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH)
cet_find_simple_package(CRY HEADERS CRYSetup.h INCPATH_SUFFIXES src)
cet_find_library(CRY CRY NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH)

# genie-config for R-2 series didn't support --version (returns blank)
# execute_process(COMMAND genie-config --version OUTPUT_VARIABLE GENIE_VERSION)
# this is the equivalent:
#execute_process(COMMAND cat ${GENIE}/VERSION OUTPUT_VARIABLE GENIE_VERSION)
#string(STRIP ${GENIE_VERSION} GENIE_VERSION)
#string(SUBSTRING ${GENIE_VERSION} 0 1 GENIE_MAJOR_VERSION)
#MESSAGE("--NUTOOLS-- GENIE_VERSION=${GENIE_VERSION} major=${GENIE_MAJOR_VERSION}")
#if( ${GENIE_MAJOR_VERSION} LESS 3 )

# use GENIE UPS version to decide ...
include(ParseVersion)
parse_underscored_version( ${GENIE_VERSION} )
#set(VMAJ 2)
#set(VMIN 12)
if( VMAJ LESS 3 )
  add_definitions(-DGENIE_PRE_R3)
#  MESSAGE("--NUTOOLS-- GENIE_VERSION=${VMAJ} ${VMIN} -DGENIE_PRE_R3")
# these are the pre-R-3 library names
  cet_find_library( GALGORITHM NAMES GAlgorithm NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GBARYONRESONANCE NAMES GBaryonResonance NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GBASE NAMES GBase NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GBODEKYANG NAMES GBodekYang NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GCHARM NAMES GCharm NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GCOH NAMES GCoh NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GDFRC NAMES GDfrc NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GDIS NAMES GDIS NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GCROSSSECTIONS NAMES GCrossSections NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GDECAY NAMES GDecay NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GELAS NAMES GElas NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GELFF NAMES GElFF NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GHEP NAMES GHEP NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GEVGCORE NAMES GEVGCore  NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GEVGMODULES NAMES GEVGModules NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GEVGDRIVERS NAMES GEVGDrivers NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GGIBUU NAMES GGiBUU NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GHADRONTRANSP NAMES GHadronTransp NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFRAGMENTATION NAMES GFragmentation NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GINTERACTION NAMES GInteraction NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GLLEWELLYNSMITH NAMES GLlewellynSmith  NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GMEC NAMES GMEC NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GMESSENGER NAMES GMessenger NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GNUGAMMA NAMES GNuGamma NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GNUE NAMES GNuE NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GNTUPLE NAMES GNtuple NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GNUCLEAR NAMES GNuclear NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GNUMERICAL NAMES GNumerical NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GQPM NAMES GQPM NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPDG NAMES GPDG NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPDF NAMES GPDF NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GQEL NAMES GQEL NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GRES NAMES GRES NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GREGISTRY NAMES GRegistry NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )

  # prior to GENIE R-2_9_0 Sehgal's name was spelled incorrectly
  # so if minor version # is 8 or less use GReinSeghal, otherwise GReinSehgal
  # parse_ups_version returns VMAJ, VMIN, and VPRJ
  #parse_ups_version( $ENV{GENIE_VERSION} )
  set ( GRSSPELLING GReinSehgal )
  if ( VMAJ EQUAL 2 AND VMIN LESS 9 )
    set ( GRSSPELLING GReinSeghal )
  endif ( VMAJ EQUAL 2 AND VMIN LESS 9 )
  message(STATUS "GENIE version ${GENIE_VERSION} major ${VMAJ} minor ${VMIN} ${GRSSPELLING}")
  cet_find_library( GREINSEHGAL NAMES ${GRSSPELLING} NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )

  cet_find_library( GUTILS NAMES GUtils NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GGEO NAMES GGeo NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFLUXDRIVERS NAMES GFluxDrivers NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GMUELOSS NAMES GMuELoss NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GREWEIGHT NAMES GReWeight NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GNUCLEONDECAY NAMES GNucleonDecay NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  set(GENIE_LIB_LIST  ${GALGORITHM}
                      ${GBARYONRESONANCE}
                      ${GBASE}
                      ${GBODEKYANG}
                      ${GCHARM}
                      ${GCOH}
                      ${GDFRC}
                      ${GDIS}
                      ${GCROSSSECTIONS}
                      ${GDECAY}
                      ${GELAS}
                      ${GELFF}
                      ${GHEP}
                      ${GEVGCORE}
                      ${GEVGMODULES}
                      ${GEVGDRIVERS}
                      ${GGIBUU}
                      ${GHADRONTRANSP}
                      ${GFRAGMENTATION}
                      ${GINTERACTION}
                      ${GLLEWELLYNSMITH}
                      ${GMEC}
                      ${GMESSENGER}
                      ${GNUGAMMA}
                      ${GNUE}
                      ${GNTUPLE}
                      ${GNUCLEAR}
                      ${GNUMERICAL}
                      ${GQPM}
                      ${GPDG}
                      ${GPDF}
                      ${GQEL}
                      ${GRES}
                      ${GREGISTRY}
                      ${GREINSEHGAL}
                      ${GUTILS}
                      ${GGEO}
                      ${GFLUXDRIVERS}
                      ${GMUELOSS}
                      ${GREWEIGHT}
                      ${GNUCLEONDECAY}
                      )
else()
# these are the POST-R-3 library names
#  MESSAGE("--NUTOOLS-- GENIE_VERSION=${VMAJ} ${VMIN} not defining -DGENIE_PRE_R3")

  cet_find_library( GFWMSG       NAMES GFwMsg       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFWREG       NAMES GFwReg       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFWALG       NAMES GFwAlg       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFWINT       NAMES GFwInt       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFWGHEP      NAMES GFwGHEP      NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFWNUM       NAMES GFwNum       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFWUTL       NAMES GFwUtl       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFWPARDAT    NAMES GFwParDat    NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFWEG        NAMES GFwEG        NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GFWNTP       NAMES GFwNtp       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHXSIG      NAMES GPhXSIg      NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHPDF       NAMES GPhPDF       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHNUCLST    NAMES GPhNuclSt    NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHCMN       NAMES GPhCmn       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHDCY       NAMES GPhDcy       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHHADTRANSP NAMES GPhHadTransp NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHHADNZ     NAMES GPhHadnz     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHDEEX      NAMES GPhDeEx      NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHAMNGXS    NAMES GPhAMNGXS    NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHAMNGEG    NAMES GPhAMNGEG    NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHCHMXS     NAMES GPhChmXS     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHCOHXS     NAMES GPhCohXS     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHCOHEG     NAMES GPhCohEG     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHDISXS     NAMES GPhDISXS     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHDISEG     NAMES GPhDISEG     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHDFRCXS    NAMES GPhDfrcXS    NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHDFRCEG    NAMES GPhDfrcEG    NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHGLWRESXS  NAMES GPhGlwResXS  NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHGLWRESEG  NAMES GPhGlwResEG  NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHIBDXS     NAMES GPhIBDXS     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHIBDEG     NAMES GPhIBDEG     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHMNUCXS    NAMES GPhMNucXS    NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHMNUCEG    NAMES GPhMNucEG    NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHMEL       NAMES GPhMEL       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHNUELXS    NAMES GPhNuElXS    NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHNUELEG    NAMES GPhNuElEG    NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHQELXS     NAMES GPhQELXS     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHQELEG     NAMES GPhQELEG     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHRESXS     NAMES GPhResXS     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHRESEG     NAMES GPhResEG     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHSTRXS     NAMES GPhStrXS     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHSTREG     NAMES GPhStrEG     NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GPHNDCY      NAMES GPhNDcy      NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GTLGEO       NAMES GTlGeo       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GTLFLX       NAMES GTlFlx       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )

  # if GENIE's Reweight gets spun into separate product
  # then the following must change for GENIE_LIB to ? GENIERW_LIB
  cet_find_library( GRWFWK       NAMES GRwFwk       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GRWIO        NAMES GRwIO        NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  cet_find_library( GRWCLC       NAMES GRwClc       NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )

  # GENIE pre-R-3 used GSL via ROOT's Math libs, now makes direct call not available via that route
  find_simple_package(gsl)

# this is the order that GENIE "recommends"
# genie-config --libs
#   -lGFwMsg -lGFwReg -lGFwAlg -lGFwInt -lGFwGHEP -lGFwNum -lGFwUtl -lGFwParDat
#   -lGFwEG -lGFwNtp -lGPhXSIg -lGPhPDF -lGPhNuclSt -lGPhCmn -lGPhDcy -lGPhHadTransp
#   -lGPhHadnz -lGPhDeEx -lGPhAMNGXS -lGPhAMNGEG -lGPhChmXS -lGPhCohXS -lGPhCohEG
#   -lGPhDISXS -lGPhDISEG -lGPhDfrcXS -lGPhDfrcEG -lGPhGlwResXS -lGPhGlwResEG
#   -lGPhIBDXS -lGPhIBDEG -lGPhMNucXS -lGPhMNucEG -lGPhMEL -lGPhNuElXS -lGPhNuElEG
#   -lGPhQELXS -lGPhQELEG -lGPhResXS -lGPhResEG -lGPhStrXS
#   -lGPhStrEG -lGPhNDcy -lGTlGeo -lGTlFlx -lGTlRew

  set (GENIE_LIB_LIST ${GFWMSG}
                      ${GFWREG}
                      ${GFWALG}
                      ${GFWINT}
                      ${GFWGHEP}
                      ${GFWNUM}
                      ${GSL}  # FWNUM relies on GSL
                      ${GFWUTL}
                      ${GFWPARDAT}
                      ${GFWEG}
                      ${GFWNTP}
                      ${GPHXSIG}
                      ${GPHPDF}
                      ${GPHNUCLST}
                      ${GPHCMN}
                      ${GPHDCY}
                      ${GPHHADTRANSP}
                      ${GPHHADNZ}
                      ${GPHDEEX}
                      ${GPHAMNGXS}
                      ${GPHAMNGEG}
                      ${GPHCHMXS}
                      ${GPHCOHXS}
                      ${GPHCOHEG}
                      ${GPHDISXS}
                      ${GPHDISEG}
                      ${GPHDFRCXS}
                      ${GPHDFRCEG}
                      ${GPHGLWRESXS}
                      ${GPHGLWRESEG}
                      ${GPHIBDXS}
                      ${GPHIBDEG}
                      ${GPHMNUCXS}
                      ${GPHMNUCEG}
                      ${GPHMEL}
                      ${GPHNUELXS}
                      ${GPHNUELEG}
                      ${GPHQELXS}
                      ${GPHQELEG}
                      ${GPHRESXS}
                      ${GPHRESEG}
                      ${GPHSTRXS}
                      ${GPHSTREG}
                      ${GPHNDCY}
                      ${GTLGEO}
                      ${GTLFLX}
                      ${GRWFWK}
                      ${GRWIO}
                      ${GRWCLC}
                      )

endif()
find_path(genie_inc
  NAMES Conventions/Units.h Framework/Conventions/Units.h
  PATH_SUFFIXES GENIE
  NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH)
include_directories(${genie_inc})

#MESSAGE("--NUTOOLS-- GENIE ${VMAJ} messenger ${GMESSENGER} gfwmsg ${GFWMSG} GENIE_LIB_LIST=${GENIE_LIB_LIST}")

# dk2nu
cet_find_simple_package(dk2nu_tree LIBNAMES dk2nuTree HEADERS dk2nu/tree/dk2nu.h)
cet_find_simple_package(dk2nu_genie LIBNAMES dk2nuGenie HEADERS dk2nu/genie/GDk2NuFlux.h)

# ifdhc
cet_find_simple_package(ifdh INCPATH_SUFFIXES inc)

# ifdhc_art  # as a service
find_package(ifdh_art)

# macros
include(ArtMake)
include(ArtDictionary)
include(BuildPlugins)
include(CetRootCint)

# include search path


# included for Mac OSX using XQuartz for X11
if(APPLE)
  include_directories ( /opt/X11/include )
endif()

# source
add_subdirectory (nutools)
#add_subdirectory (tools)
add_subdirectory (test)
add_subdirectory(cmakeConfig)
# ups - table and config files
#add_subdirectory(ups)

# packaging utility
#include(UseCPack)

