########################################################################
# Adapted from build-framework to describe the nu and nulite
# distributions.
########################################################################

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
if (POLICY CMP0048)
  # Prevent dev complaint about lack of VERSION in project() call for
  # CMake >=3.0.
  cmake_policy(SET CMP0048 NEW)
endif()
project(nutools_bundles NONE)

# Define some necessary modules.
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap)
include(bootstrapModules)

# for use in html
set( supported_quals_string "e19|e20|c7")

# Package Management.
create_version_variables(cetpkgsupport v1_14_01)
create_version_variables(ups v6_0_8)

# Handle Python version(s).
create_version_variables(python v3_8_3b)
create_version_variables(python3 NAME python v3_8_3b)
create_pyqual_variables()

create_version_variables(cmake LIST v3_17_3 v3_18_2 v3_19_6 v3_20_0)

create_version_variables(lhapdf v6_2_3f)

create_version_variables(sqlite v3_32_03_00)

# TAUOLA C++ and friends
create_version_variables(hepmc3 v3_2_2b)
create_version_variables(pythia8 v8_3_02e)
create_version_variables(tauola v1_1_8h)
create_version_variables(tauola_dist NAME tauola ${TAUOLA_VERSION})

# Initialize CMake variables containing shell fragments used by bundle
# configurations.
init_shell_fragment_vars()

########################################################################
# No calls to create_version_variables() beyond this point.
########################################################################

# These files should be copied to SciSoft for each release.

# Tauola C++ & friends.
distribution(tauola_dist)
