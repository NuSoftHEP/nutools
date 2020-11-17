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

# Package Management.
create_version_variables(cetpkgsupport v1_14_01)
create_version_variables(ups v6_0_8)

# Handle Python version(s).
create_version_variables(python v2_7_15a)
create_version_variables(python3 NAME python v3_8_3b)
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
create_version_variables(canvas v3_10_02${suite_rc_level})
create_version_variables(canvas_stack ${CANVAS_VERSION}${stack_suffix})
create_version_variables(studio v1_02_00)
create_version_variables(canvas_root_io v1_06_02)
create_version_variables(art v3_06_03)
create_version_variables(art_suite NAME art ${ART_VERSION}${suite_rc_level})
create_version_variables(art_root_io v1_04_03)

# lite framework
create_product_variables(gallery v1_15_02${suite_rc_level})

# Tutorial
create_version_variables(toyExperiment v0_05_07)

create_product_variables(cry v1_7n)
create_product_variables(TRACE v3_16_00)
create_product_variables(artdaq_core v3_06_03)

# geant4
create_product_variables(geant4 v4_10_6_p01c)
create_product_variables(xerces_c v3_2_3a)
create_product_variables(vecgeom v01_01_05c)
create_product_variables(qt v5_12_3a)
create_product_variables(g4abla v3_1)
create_product_variables(g4emlow v7_9_1)
create_product_variables(g4incl v1_0)
create_product_variables(g4neutron v4_6)
create_product_variables(g4nucleonxs v2_0)
create_product_variables(g4nuclide v2_2)
create_product_variables(g4particlexs v2_1)
create_product_variables(g4photon v5_5)
create_product_variables(g4pii v1_3)
create_product_variables(g4radiative v5_4)
create_product_variables(g4surface v2_1_1)
create_product_variables(g4tendl v1_3_2)
create_product_variables(geant4reweight v01_04_00)

# ifdh
create_version_variables(libwda v2_28_0)
create_version_variables(ifdhc v2_5_10)
create_version_variables(ifdhc_config v2_5_10)
create_version_variables(ifbeam v2_4_7)
create_version_variables(nucondb v2_4_7)
create_version_variables(ifdh_art v2_11_04)
# IFDH distribution.
create_version_variables(ifdh ${IFDH_ART_VERSION})

# nu_extras
create_product_variables(genie v3_00_06j)
create_product_variables(genie_phyopt v3_00_04)
create_product_variables(genie_xsec v3_00_04a)
create_product_variables(lhapdf v6_2_3f)
create_product_variables(log4cpp v1_1_3c)
create_product_variables(dk2nudata v01_08_00h)
create_product_variables(dk2nugenie v01_08_00m)
create_product_variables(ppfx v02_12_01)
create_version_variables(protobuf v3_12_3)
create_version_variables(tensorflow v1_12_0c)
create_product_variables(pygccxml v1_9_1)
create_version_variables(pygccxml v1_9_1b)

create_version_variables(openblas v0_3_10a)
# create_version_variables(numpy v1_19_0b)
create_version_variables(pybind11 v2_5_0a)
create_version_variables(protobuf v3_12_3)
create_version_variables(eigen v3_3_5)
create_version_variables(fftw v3_3_8a)
create_version_variables(gmp v6_2_0)
create_version_variables(mpfr v4_1_0)
create_version_variables(libtorch v1_6_0)
create_version_variables(libtorch_dist NAME libtorch ${LIBTORCH_VERSION})

# CodeSynthesis XSD for NoVA.
#
# Special build-time-only xerces_c required for cstxsd.
create_version_variables(cstxsd_xerces_c NAME xerces_c v3_2_3a)
create_version_variables(cstxsd v4_0_0j)
create_version_variables(cstxsd_dist NAME cstxsd ${CSTXSD_VERSION})

# nutools
create_product_variables(nusimdata v1_21_02)
create_product_variables(nuevdb v1_02_06)
create_product_variables(nug4 v1_05_01)
create_product_variables(nugen v1_10_09)
create_product_variables(nurandom v1_04_03)

create_version_variables(nutools v3_09_00)
create_version_variables(nutools_dist NAME nutools ${NUTOOLS_VERSION})
set(nulite_suffix _rc0) # Reset when no longer needed
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

# libtorch.
distribution(libtorch_dist)
