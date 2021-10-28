########################################################################
# Adapted from build-framework to describe the nu and nulite
# distributions.
########################################################################

cmake_minimum_required(VERSION 2.6)
project(nutools_bundles NONE)

# Define some necessary modules.
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap)
include(bootstrapModules)

# Define version set for desired version of art suite.
set(version_set s97)
set( supported_quals_string "e19|c7")

# Package Management.
create_version_variables(cetpkgsupport v1_14_01)
create_version_variables(ups v6_0_8)

# Handle Python version(s).
create_version_variables(python v2_7_15a)
create_version_variables(python3 NAME python v3_7_2)
create_pyqual_variables()

# CMake and cetbuildtools are special: define as many versions as
# necessary.
create_version_variables(cmake LIST v3_17_3)
create_version_variables(cetbuildtools LIST
  v7_11_00
  v7_12_01
  v7_13_02
  v7_14_00
  v7_15_01
  v7_17_01
  )

# Required by TRACE >= v3_14_00.
create_version_variables(cetmodules v1_04_00)

# art_suite
#set(suite_rc_level _rc0)
#set(stack_suffix b) # Reset when no longer needed
create_version_variables(canvas v3_09_01${suite_rc_level})
create_version_variables(canvas_stack ${CANVAS_VERSION}${stack_suffix})
create_version_variables(studio v1_02_00)
create_version_variables(canvas_root_io v1_05_02)
create_version_variables(art v3_05_01)
create_version_variables(art_suite NAME art ${ART_VERSION}${suite_rc_level})
create_version_variables(art_root_io v1_03_01)

# Tutorial
create_version_variables(toyExperiment v0_05_03)

create_version_variables(cry v1_7m)
create_version_variables(TRACE v3_15_07)
create_version_variables(artdaq_core v3_05_15)

# geant4
create_version_variables(geant4 v4_10_4_p02d)
create_version_variables(xerces_c v3_2_2)
create_version_variables(vecgeom v00_05_01)
create_version_variables(qt v5_10_1a)
create_version_variables(g4abla v3_1)
create_version_variables(g4emlow v7_3)
create_version_variables(g4neutron v4_5)
create_version_variables(g4neutronxs v1_4)
create_version_variables(g4nucleonxs v1_1)
create_version_variables(g4nuclide v2_2)
create_version_variables(g4photon v5_2)
create_version_variables(g4pii v1_3)
create_version_variables(g4radiative v5_2)
create_version_variables(g4surface v2_1_1)
create_version_variables(g4tendl v1_3_2)
create_version_variables(geant4reweight v01_04_03)

# ifdh
create_version_variables(libwda v2_28_0)
create_version_variables(ifdhc v2_5_7)
create_version_variables(ifdhc_config v2_5_10)
create_version_variables(ifbeam v2_4_5)
create_version_variables(nucondb v2_4_5)
create_version_variables(ifdh_art v2_10_07)
# IFDH distribution.
create_version_variables(ifdh ${IFDH_ART_VERSION})

# nu_extras
create_version_variables(genie v3_00_06_p01a)
create_version_variables(genie_phyopt v3_00_04)
create_version_variables(genie_xsec v3_00_04a)
create_version_variables(log4cpp v1_1_3b)
create_version_variables(dk2nugenie v01_08_00ea)
create_version_variables(dk2nudata v01_08_00g)
create_version_variables(ppfx v02_10_01)
create_version_variables(protobuf v3_11_2a)
create_version_variables(tensorflow v1_12_0c)
create_version_variables(pygccxml v1_9_1b)
create_version_variables(eigen v3_4_0)
create_version_variables( sundials v5_8_0 )
create_version_variables( stan_math v4_2_1 )
create_version_variables( stan v2_28_1 )

# CodeSynthesis XSD for NoVA.
#
# Special build-time-only xerces_c required for cstxsd.
create_version_variables(cstxsd_xerces_c NAME xerces_c v3_2_3a)
create_version_variables(cstxsd v4_0_0j)
create_version_variables(cstxsd_dist NAME cstxsd ${CSTXSD_VERSION})

create_version_variables(lhapdf v6_2_3d)

# nutools
create_version_variables(nusimdata v1_21_02)
create_version_variables(nuevdb v1_02_05_01)
create_version_variables(nug4 v1_04_04)
create_version_variables(nugen v1_06_05)

create_version_variables(nutools v3_08_00)
create_version_variables(nutools_dist NAME nutools ${NUTOOLS_VERSION})
set(nulite_suffix b) # Reset when no longer needed.
create_version_variables(nulite ${NUTOOLS_VERSION}${nulite_suffix})

create_version_variables(nulite_base ${NULITE_VERSION})
create_version_variables(nubase ${NULITE_VERSION})
create_version_variables(nu ${NULITE_VERSION})

# NOvA
create_version_variables(castxml v0_00_00_f20180122)

# Initialize CMake variables containing shell fragments used by bundle
# configurations.
init_shell_fragment_vars()

########################################################################
# No calls to create_version_variables() beyond this point.
########################################################################

# These files should be copied to SciSoft for each release.

# nu (NOvA uses nu and nulite).
distribution(cstxsd_dist)
distribution(nubase)
distribution(nu WITH_HTML)

# nulite (LArSoft uses nulite, but not nu).
distribution(nulite_base)
distribution(nulite WITH_HTML)

# ifdh.
distribution(ifdh)

# stan
distribution(stan)
