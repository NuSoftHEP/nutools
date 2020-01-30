# we are bootstrapping, so we don't want to use cetbuildtools
# these modules are strictly for build-framework

include(CMakeParseArguments)

# keeping a reference copy of the old macro
# flavorqual is used in the obsolete tools/CMakeLists.txt
macro( set_flavor_qual_obsolete arch )

   set( SLTYPE ${arch} )
   set( UPSFLAVOR ${arch} )
   if( ${arch} MATCHES "noarch" )
       set( UPSFLAVOR NULL )
   endif ()
   SET (flavorqual ${SLTYPE}.${qualifier} )
   SET (flavorqual_dir ${product}/${version}/${flavorqual} )

   # check for extra qualifiers
   #message(STATUS "set_flavor_qual_obsolete: build type is ${CMAKE_BUILD_TYPE}")
   if( NOT  CMAKE_BUILD_TYPE )
      SET( extra_qualifier "" )
      set( full_qualifier ${qualifier} )
   else()
      message(STATUS "set_flavor_qual_obsolete: found build type ${CMAKE_BUILD_TYPE}" )
      STRING(TOLOWER ${CMAKE_BUILD_TYPE} extra_qualifier)
      set( flavorqual_dir ${product}/${version}/${flavorqual}.${extra_qualifier} )
      SET (flavorqual ${flavorqual}.${extra_qualifier})
      set( full_qualifier ${qualifier}:${extra_qualifier} )
   endif()
   #message(STATUS "set_flavor_qual_obsolete: flavorqual is ${flavorqual}" )
   #message(STATUS "set_flavor_qual_obsolete: full_qualifier is ${full_qualifier}" )
   #message(STATUS "set_flavor_qual_obsolete: ups flavor is ${UPSFLAVOR}" )
   #message(STATUS "set_flavor_qual_obsolete: flavorqual diredctory is ${flavorqual_dir}" )

endmacro( set_flavor_qual_obsolete )

macro( create_product_variables productname productversion)
   string(TOUPPER ${productname} PRODUCTNAME_UC )
   string(TOLOWER ${productname} PRODUCTNAME_LC )

   # require ${PRODUCTNAME_UC}_VERSION
   set( ${PRODUCTNAME_UC}_VERSION "${productversion}" )
   if ( NOT ${PRODUCTNAME_UC}_VERSION )
     message(FATAL_ERROR "product version is not defined")
   endif ()
   STRING( REGEX REPLACE "_" "." VDOT "${productversion}"  )
   STRING( REGEX REPLACE "^[v]" "" ${PRODUCTNAME_UC}_DOT_VERSION "${VDOT}" )
   set( ${PRODUCTNAME_UC}_STRING ${PRODUCTNAME_LC}.${${PRODUCTNAME_UC}_DOT_VERSION} )
   #message(STATUS "${PRODUCTNAME_UC} version is ${${PRODUCTNAME_UC}_VERSION}")
   #message(STATUS "${PRODUCTNAME_UC} string is ${${PRODUCTNAME_UC}_STRING}")
endmacro( create_product_variables)

function(_create_pyqual VERSION_IN VAR)
  string( REGEX REPLACE "_" "" PYVER "${VERSION_IN}" )
  string( REGEX REPLACE "^[v]" "p" PYQUAL "${PYVER}" )  
  set(${VAR} ${PYQUAL} PARENT_SCOPE)
endfunction()

macro(create_pyqual_variables)
  if (PYTHON_VERSION)
    _create_pyqual(${PYTHON_VERSION} PYQUAL)
  endif()
  if (PYTHON3_VERSION)
    _create_pyqual(${PYTHON3_VERSION} PY3QUAL)
  endif()
endmacro()

function(create_source_manifest_for productname)
  string(TOUPPER ${productname} PRODUCTNAME_UC)
#  foreach (productversion ${${PRODUCTNAME_UC}_VERSION_LIST})
  foreach (productversion ${ARGN})
   string(REGEX REPLACE "_" "." vdot "${productversion}"  )
   string(REGEX REPLACE "^[v]" "" dot_version "${vdot}" )
   if (mfrag)
     set(mfrag "${mfrag}\n")
   endif()
   set(mfrag "${mfrag}${productname}\t\t${productversion}\t\t${productname}-${dot_version}-source.tar.bz2")
  endforeach()
  set(${PRODUCTNAME_UC}_SOURCE_MANIFEST "${mfrag}" PARENT_SCOPE)
endfunction()

function( create_product_variable_list productname )
   cmake_parse_arguments(CPVL "" "" "QUALIFIERS" ${ARGN})
   STRING(REGEX REPLACE ";" ":" CPVL_QUALIFIERS "${CPVL_QUALIFIERS}")
   #message(STATUS "create_product_variables: ${productname} ${ARGN} ")
   string(TOUPPER ${productname} PRODUCTNAME_UC )
   string(TOLOWER ${productname} PRODUCTNAME_LC )

   STRING( REGEX REPLACE ";" " " vlist "${CPVL_UNPARSED_ARGUMENTS}" )
   set(${PRODUCTNAME_UC}_VERSION_LIST "${vlist}" PARENT_SCOPE)
   message(STATUS "${PRODUCTNAME_UC} version list is ${vlist}")
   if (CPVL_QUALIFIERS)
     set(${PRODUCTNAME_UC}_QUAL "${CPVL_QUALIFIERS}" PARENT_SCOPE)
     message(STATUS "${PRODUCTNAME_UC} qualifiers: ${CPVL_QUALIFERS}")
   endif()
   create_source_manifest_for(${productname} ${CPVL_UNPARSED_ARGUMENTS})
   set(${PRODUCTNAME_UC}_SOURCE_MANIFEST "${${PRODUCTNAME_UC}_SOURCE_MANIFEST}" PARENT_SCOPE)
endfunction( create_product_variable_list )

macro( set_version_from_ups UPS_VERSION )

  STRING( REGEX REPLACE "^[v](.*)[_](.*)[_](.*)$" "\\1" VMAJ "${UPS_VERSION}" )
  STRING( REGEX REPLACE "^[v](.*)[_](.*)[_](.*)$" "\\2" VMIN "${UPS_VERSION}" )
  STRING( REGEX REPLACE "^[v](.*)[_](.*)[_](.*)$" "\\3" VPRJ "${UPS_VERSION}" )
  #message(STATUS "version parses to ${VMAJ}.${VMIN}.${VPRJ}" )

  set( VERSION_MAJOR ${VMAJ} )
  set( VERSION_MINOR ${VMIN} )
  set( VERSION_PATCH ${VPRJ} )
  message(STATUS "project version is ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}" )

endmacro( set_version_from_ups )

#
# Runs compiler with "-dumpversion" and parses major/minor
# version with a regex.
#
FUNCTION(_My_COMPILER_DUMPVERSION _OUTPUT_VERSION)

  EXEC_PROGRAM(${CMAKE_CXX_COMPILER}
    ARGS ${CMAKE_CXX_COMPILER_ARG1} -dumpversion
    OUTPUT_VARIABLE _my_COMPILER_VERSION
  )
  set( COMPILER_VERSION ${_my_COMPILER_VERSION} PARENT_SCOPE)
  STRING(REGEX REPLACE "([0-9])\\.([0-9])(\\.[0-9])?" "\\1\\2"
    _my_COMPILER_VERSION ${_my_COMPILER_VERSION})

  SET(${_OUTPUT_VERSION} ${_my_COMPILER_VERSION} PARENT_SCOPE)
ENDFUNCTION()


macro( find_compiler )
  if (My_COMPILER)
      SET (CPack_COMPILER_STRING ${My_COMPILER})
      message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ] "
                     "using user-specified My_COMPILER = ${CPack_COMPILER_STRING}")
  else(My_COMPILER)
    # Attempt to guess the compiler suffix
    # NOTE: this is not perfect yet, if you experience any issues
    # please report them and use the My_COMPILER variable
    # to work around the problems.
    if (MSVC90)
      SET (CPack_COMPILER_STRING "-vc90")
    elseif (MSVC80)
      SET (CPack_COMPILER_STRING "-vc80")
    elseif (MSVC71)
      SET (CPack_COMPILER_STRING "-vc71")
    elseif (MSVC70) # Good luck!
      SET (CPack_COMPILER_STRING "-vc7") # yes, this is correct
    elseif (MSVC60) # Good luck!
      SET (CPack_COMPILER_STRING "-vc6") # yes, this is correct
    elseif (BORLAND)
      SET (CPack_COMPILER_STRING "-bcb")
    elseif("${CMAKE_CXX_COMPILER}" MATCHES "icl"
        OR "${CMAKE_CXX_COMPILER}" MATCHES "icpc")
      if(WIN32)
        set (CPack_COMPILER_STRING "-iw")
      else()
        set (CPack_COMPILER_STRING "-il")
      endif()
    elseif (MINGW)
        _My_COMPILER_DUMPVERSION(CPack_COMPILER_STRING_VERSION)
        SET (CPack_COMPILER_STRING "-mgw${CPack_COMPILER_STRING_VERSION}")
    elseif (UNIX)
      if (CMAKE_COMPILER_IS_GNUCXX)
          _My_COMPILER_DUMPVERSION(CPack_COMPILER_STRING_VERSION)
          # Determine which version of GCC we have.
	  if(APPLE)
              SET (CPack_COMPILER_STRING "-xgcc${CPack_COMPILER_STRING_VERSION}")
	  else()
              SET (CPack_COMPILER_STRING "-gcc${CPack_COMPILER_STRING_VERSION}")
	  endif()
      endif (CMAKE_COMPILER_IS_GNUCXX)
    endif()
    message(STATUS "Using compiler ${CPack_COMPILER_STRING}")
  endif(My_COMPILER)
endmacro( find_compiler )
