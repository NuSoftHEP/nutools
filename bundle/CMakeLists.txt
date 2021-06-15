########################################################################
# Adapted from build-framework to describe the nu and nulite
# distributions.
########################################################################

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(nutools_bundles NONE)

# Define some necessary modules.
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap)
include(bootstrapModules)

# Define version set for desired version of art suite.
set(version_set s106)
# for use in html
set( supported_quals_string "e19|e20|c7")

# Package Management.
create_version_variables(cetpkgsupport v1_14_01)
create_version_variables(ups v6_0_8)

# Handle Python version(s).
create_version_variables(python v2_7_15a)
create_version_variables(python3 NAME python v3_8_3b)
create_pyqual_variables()

# CMake and cetbuildtools are special: define as many versions as
# necessary.
create_version_variables(cmake LIST v3_17_3 v3_18_2)
create_version_variables(cetbuildtools
  LIST
  v7_11_00
  v7_12_01
  v7_13_02
  v7_14_00
  v7_15_01
  v7_17_01
  )

# cetmodules v1_04_00 is required by TRACE >= v3_14_00.
create_version_variables(cetmodules1 v1_04_00)
create_version_variables(cetmodules v2_05_03)

# art_suite
set(suite_rc_level)
set(stack_suffix c) # Reset when no longer needed
set(art_suffix c) # Reset when no longer needed
create_version_variables(canvas v3_10_02${suite_rc_level})
create_version_variables(canvas_stack ${CANVAS_VERSION}${stack_suffix})
create_version_variables(studio v1_02_00)
create_version_variables(canvas_root_io v1_07_02)
create_version_variables(art v3_06_03${suite_rc_level})
create_version_variables(art_suite NAME art ${ART_VERSION}${art_suffix})
create_version_variables(art_root_io v1_05_02)

# lite framework
create_version_variables(gallery v1_16_02${suite_rc_level})

# Tutorial
create_version_variables(toyExperiment v0_05_10)

create_version_variables(cry v1_7n)
create_version_variables(TRACE v3_16_02)
create_version_variables(artdaq_core v3_06_09)

# geant4
create_version_variables(geant4 v4_10_6_p01c)
create_version_variables(xerces_c v3_2_3a)
create_version_variables(vecgeom v01_01_05c)
create_version_variables(qt v5_12_3a)
create_version_variables(g4abla v3_1)
create_version_variables(g4emlow v7_9_1)
create_version_variables(g4incl v1_0)
create_version_variables(g4neutron v4_6)
create_version_variables(g4nucleonxs v2_0)
create_version_variables(g4nuclide v2_2)
create_version_variables(g4particlexs v2_1)
create_version_variables(g4photon v5_5)
create_version_variables(g4pii v1_3)
create_version_variables(g4radiative v5_4)
create_version_variables(g4surface v2_1_1)
create_version_variables(g4tendl v1_3_2)
create_version_variables(geant4reweight v01_06_07)

# ifdh
create_version_variables(libwda v2_29_1)
create_version_variables(ifdhc v2_5_13)
create_version_variables(ifdhc_config v2_5_13)
create_version_variables(ifbeam v2_5_0)
create_version_variables(nucondb v2_4_9)
create_version_variables(ifdh_art v2_11_06)
# IFDH distribution.
create_version_variables(ifdh ${IFDH_ART_VERSION})

# nu_extras
create_version_variables(genie v3_00_06k)
create_version_variables(genie_phyopt v3_00_04)
create_version_variables(genie_xsec v3_00_04a)
create_version_variables(lhapdf v6_2_3f)
create_version_variables(log4cpp v1_1_3c)
create_version_variables(dk2nudata v01_10_00)
create_version_variables(dk2nugenie v01_10_00)
create_version_variables(ppfx v02_13_03)
create_version_variables(protobuf v3_12_3a)
create_version_variables(tensorflow v2_3_1a)
create_version_variables(tensorflow_dist NAME tensorflow ${TENSORFLOW_VERSION})
create_version_variables(pygccxml v2_1_0)

create_version_variables(sqlite v3_32_03_00)
create_version_variables(openblas v0_3_10a)
# create_version_variables(numpy v1_19_0b)
create_version_variables(pybind11 v2_5_0a)
create_version_variables(eigen v3_3_9a)
create_version_variables(fftw v3_3_8a)
create_version_variables(gmp v6_2_0)
create_version_variables(mpfr v4_1_0)
create_version_variables(grpc v1_35_0)
create_product_variables(opencv v4_2_0a)
create_version_variables(libtorch v1_6_0b)
create_version_variables(libtorch_dist NAME libtorch ${LIBTORCH_VERSION})
create_version_variables(triton v2_3_0b)
create_version_variables(triton_dist NAME triton ${TRITON_VERSION})


# CodeSynthesis XSD for NoVA.
#
# Special build-time-only xerces_c required for cstxsd.
create_version_variables(cstxsd_xerces_c NAME xerces_c v3_2_3a)
create_version_variables(cstxsd v4_0_0j)
create_version_variables(cstxsd_dist NAME cstxsd ${CSTXSD_VERSION})
message(STATUS "found cstxsd_dist ${CSTXSD_DIST_VERSION}")

# nutools
create_version_variables(nusimdata v1_22_03)
create_version_variables(nuevdb v1_03_04)
create_version_variables(nug4 v1_07_01)
create_version_variables(nugen v1_12_01)
create_version_variables(nurandom v1_05_02)

create_version_variables(nutools v3_09_03)
create_version_variables(nutools_dist NAME nutools ${NUTOOLS_VERSION})
set(nulite_suffix) # Reset when no longer needed
create_version_variables(nulite ${NUTOOLS_VERSION}${nulite_suffix})

create_version_variables(nulite_base ${NULITE_VERSION})
create_version_variables(nubase ${NULITE_VERSION})
create_version_variables(nu ${NULITE_VERSION})

# NOvA
create_version_variables(castxml v0_4_2)

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

# libtorch.
distribution(libtorch_dist)
# triton.
distribution(triton_dist)
# tensorflow.
distribution(tensorflow_dist)

