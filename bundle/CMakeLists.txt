########################################################################
# Adapted from build-framework to describe the nu and nulite
# distributions.
########################################################################

cmake_minimum_required(VERSION 3.18.2 FATAL_ERROR)
if (POLICY CMP0048)
  # Prevent dev complaint about lack of VERSION in project() call for
  # CMake >=3.0.
  cmake_policy(SET CMP0048 NEW)
endif()
project(nutools_bundles NONE)

# Define some necessary modules.
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap)
include(bootstrapModules)

# Define version set for desired version of art suite.
set(version_set s131)
# for use in html
set( supported_quals_string "e26|e28|c14")

# Package Management.
create_version_variables(cetpkgsupport v1_14_01)
create_version_variables(ups v6_1_1)

# Handle Python version(s).
create_version_variables(python v3_9_15)
create_version_variables(python3 NAME python v3_9_13)
create_pyqual_variables()
create_version_variables(pycurl v7_45_2)

# CMake and cetmodules are special: define as many versions as necessary.
# cmake v3_14_3 needed for geant4 v4_10_6_p01g
create_version_variables(cmake LIST v3_14_3 v3_20_0 v3_22_2 v3_24_1 v3_25_2 v3_27_4)
##create_version_variables(cetbuildtools LIST v8_20_00)
# cetmodules v1_04_00 is required by TRACE >= v3_14_00.
create_version_variables(cetmodules1 v1_04_00)
create_version_variables(cetmodules 
                         LIST
                           v3_20_00 v3_21_00 v3_21_01 v3_21_02 v3_22_02 v3_24_01)
# mrb
create_version_variables( hub v2_14_2 )
create_version_variables( gh v2_25_1 )
create_version_variables(mrb v6_09_06)
# ninja
create_version_variables(ninja v1_11_1)

# art_suite
set(suite_rc_level)
set(stack_suffix a) # Reset when no longer needed
set(art_suffix a) # Reset when no longer needed
create_version_variables(canvas v3_16_04)
create_version_variables(canvas_stack ${CANVAS_VERSION}${stack_suffix})
create_version_variables(studio v1_02_00)
create_version_variables(canvas_root_io v1_13_06)
create_version_variables(art v3_14_04)
create_version_variables(art_suite NAME art ${ART_VERSION}${art_suffix})
create_version_variables(art_root_io v1_13_06)

# lite framework
create_version_variables(gallery v1_22_06)

# Tutorial
create_version_variables(toyExperiment v0_10_06)

create_version_variables(cry v1_7q)
create_version_variables(TRACE v3_17_11)
create_version_variables(artdaq_core v3_10_02)

# geant4
create_version_variables(geant4 v4_10_6_p01g)
create_version_variables(xerces_c v3_2_3e)
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
create_version_variables(geant4reweight v01_20_08)

# ifdh
create_version_variables(libwda v2_30_0a)
create_version_variables(ifdhc v2_6_20)
create_version_variables(ifdhc_config v2_6_20)
create_version_variables(ifbeam v2_5_23)
create_version_variables(nucondb v2_5_23)
create_version_variables(ifdh_art v2_17_04)
# IFDH distribution.
create_version_variables(ifdh ${IFDH_ART_VERSION})

# nu_extras
create_version_variables(genie v3_04_02)
create_version_variables(genie_phyopt v3_04_00)
create_version_variables(genie_xsec v3_04_00)
create_version_variables(lhapdf v6_5_4)
create_version_variables(log4cpp v1_1_3e)
create_version_variables(dk2nudata v01_10_01h)
create_version_variables(dk2nugenie v01_10_01q)
create_version_variables(abseil_cpp v20230802_1)
create_version_variables(protobuf v3_21_12a)
create_version_variables(pygccxml v2_2_1b)
create_version_variables(inclxx v5_2_9_5f)
# tensorflow
create_version_variables(eigen v23_08_01_66e8f)
create_version_variables(bazelisk v1_10_1b)
create_version_variables(cython v0_29_33)
create_version_variables(giflib v5_2_1)
create_version_variables(libpng v1_6_37)
create_version_variables(nasm v2_14_02)
create_version_variables(libjpeg_turbo v2_1_0)
create_version_variables(tensorflow v2_15_0)
create_version_variables(tensorflow_dist NAME tensorflow ${TENSORFLOW_VERSION})

create_version_variables(sqlite v3_40_01_00)
create_version_variables(openblas v0_3_23)
create_version_variables(numpy v1_24_3)
create_version_variables(tbb v2021_9_0)
create_version_variables(pybind11 v2_10_4)
create_version_variables(fftw v3_3_10)
create_version_variables(gmp v6_2_0)
create_version_variables(mpfr v4_1_0)
create_version_variables(grpc v1_35_0c)
#create_version_variables(opencv v4_7_0a)
create_version_variables(libtorch v2_1_1b)
create_version_variables(libtorch_dist NAME libtorch ${LIBTORCH_VERSION})
create_version_variables( torch_scatter   v2_1_2a )
create_version_variables(triton v2_25_0d)
create_version_variables(triton_dist NAME triton ${TRITON_VERSION})

# TAUOLA C++ and friends
create_version_variables(hepmc3 v3_2_7)
create_version_variables(pythia8 v8_3_10)
create_version_variables(tauola v1_1_8l)
create_version_variables(tauola_dist NAME tauola ${TAUOLA_VERSION})

# CodeSynthesis XSD for NoVA.
#
# Special build-time-only xerces_c required for cstxsd.
create_version_variables(cstxsd_xerces_c NAME xerces_c v3_2_3a)
create_version_variables(cstxsd v4_0_0j)
create_version_variables(cstxsd_dist NAME cstxsd ${CSTXSD_VERSION})

# nutools
create_version_variables(nusimdata v1_28_06)
create_version_variables(nufinder v1_02_01)
create_version_variables(nuevdb v1_09_08)
create_version_variables(nug4 v1_16_06)
create_version_variables(nugen v1_21_00)
# nurandom and nusystematics are only used by LArSoft
create_version_variables(nurandom v1_11_05)
create_version_variables(systematicstools v01_04_04)
create_version_variables(nusystematics v1_05_00)

create_version_variables(nutools v3_17_00)
create_version_variables(nutools_dist NAME nutools ${NUTOOLS_VERSION})
set(nulite_suffix ) # Reset when no longer needed
create_version_variables(nulite ${NUTOOLS_VERSION}${nulite_suffix})

create_version_variables(nulite_base ${NULITE_VERSION})
create_version_variables(nubase ${NULITE_VERSION})
create_version_variables(nu ${NULITE_VERSION})

create_version_variables(ppfx v02_20_01)

# NOvA
create_version_variables(castxml v0_5_1)

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
distribution(ifdhc)

# libtorch.
distribution(libtorch_dist)
# triton.
distribution(triton_dist)
# tensorflow.
distribution(tensorflow_dist)

# Tauola C++ & friends.
distribution(tauola_dist)
