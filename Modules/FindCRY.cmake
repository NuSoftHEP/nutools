#[================================================================[.rst:
FindCRY
----------

Finds CRY library and headers

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``CRY::CRY``
  The CRY library


#]================================================================]
# headers
find_file(_cet_CRYSetup_h NAMES CRYSetup.h HINTS ENV CRYHOME 
  PATH_SUFFIXES src)
if (_cet_CRYSetup_h)
  get_filename_component(_cet_CRY_include_dir "${_cet_CRYSetup_h}" PATH)
  if (_cet_CRY_include_dir STREQUAL "/")
    unset(_cet_CRY_include_dir)
  endif()
endif()
if (EXISTS "${_cet_CRY_include_dir}")
  set(CRY_FOUND TRUE)
  get_filename_component(_cet_CRY_dir "${_cet_CRY_include_dir}" PATH)
  if (_cet_CRY_dir STREQUAL "/")
    unset(_cet_CRY_dir)
  endif()
  set(CRY_INCLUDE_DIRS "${_cet_CRY_include_dir}")
  set(CRY_LIBRARY_DIR "${_cet_CRY_dir}/lib}")
endif()
if (CRY_FOUND)
  find_library(CRY_LIBRARY NAMES CRY PATHS ${CRY_LIBRARY_DIR})
  if (NOT TARGET CRY::CRY)
    add_library(CRY::CRY SHARED IMPORTED)
    set_target_properties(CRY::CRY PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${CRY_INCLUDE_DIRS}"
      IMPORTED_LOCATION "${CRY_LIBRARY}"
      )
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CRY
  REQUIRED_VARS CRY_FOUND
  CRY_INCLUDE_DIRS
  CRY_LIBRARY)

unset(_cet_CRY_FIND_REQUIRED)
unset(_cet_CRY_dir)
unset(_cet_CRY_include_dir)
unset(_cet_CRYSetup_h CACHE)

