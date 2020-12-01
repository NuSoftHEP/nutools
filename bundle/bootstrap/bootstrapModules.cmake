########################################################################
# bootstrapModules.cmake
#
#   Support functions and macros for building distributions.
#
####################################
# Functions.
#
# * create_version_variables(<var-stem> [NAME <name>] [LIST] <version>...
#                            [QUALIFIERS <qualifier-list>)
#
#   Set variables X_NAME, X_VERSION and X_DOT_VERSION, where X is
#   <var-stem> converted to upper case. In most cases X_NAME will be
#   <var-stem>, but occasionally something else is appropriate and the
#   optional NAME should be used to specify something else (e.g. the UPS
#   product name or the bundle configuration filename stem). If either
#   LIST or more than one <version> is specified, the version variables
#   will have _LIST appended to their names. If QUALIFIERS is specified,
#   then X_QUAL will be set to <qualifier-list>, with \`:\' as the
#   delimiter.
#
# * create_product_variables(<product> <version>)
# * create_product_variable_list(<var-stem>
#                               [<product-version> [<product-version>]]
#                               [QUALIFIERS <qualifier-list>])
#
#   Deprecated functions retained for backward compatibility; their use
#   will elicit a warning.
#
# * create_pyqual_variables()
#
#   Create PYQUAL or PY2QUAL and PY3QUAL as appropriate, depending on
#   the required level of support for Python 2 and/or Python 3.
#
# * init_shell_fragment_vars()
#
#   Create CMake variables useful for expansion in bundle configuration
#   files via CMake's @VAR@ notation.
#
#   Variables defined:
#
#   * INIT_PYQUAL_VARS
#
#     This shell fragment will define pyver, pyqual and pylabel as
#     appropriate based on the required level of support for Python 2
#     and/or Python 3.
#
#   * BUILD_COMPILERS
#
#     This shell fragment will ensure the correct compilers are built
#     and available for the qualifier in use for the current
#     distribution.
#
#   N.B. init_shell_fragment_vars() should be called after all calls to
#   create_*() functions, but before any calls to process bundle
#   configuration files via (e.g.) distribution() or html().
#
# * distribution(<var-stem> [WITH_HTML])
#
#   Generate the bundle configuration ${X_NAME}-${X_DOT_VERSION}-cfg
#   from ${X_NAME}-cfg.in, where X is <var-stem> converted to upper
#   case. If WITH_HTML is specified, also generate the HTML file for
#   ${X_NAME}-${X_VERSION}.html from ${X_NAME}.html.in. This function
#   also generates the variable DIST_BUILD_SPEC and makes it
#   available during the file generation phase for substitution CMake's
#   @VAR@ notation.
#
########################################################################
cmake_policy(PUSH)
cmake_minimum_required(VERSION 2.8...3.18 FATAL_ERROR)

include(CMakeParseArguments)

function(create_version_variables VAR_STEM)
  _verify_before_init_shell_fragment_vars(
    "create_version_variables(${ARGV})")
  cmake_parse_arguments(CVV "LIST" "NAME" "QUALIFIERS" ${ARGN})
  if (NOT VAR_STEM)
    message(FATAL_ERROR "vacuous VAR_STEM")
  elseif (NOT CVV_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "No versions specified")
  endif()
  string(TOUPPER ${VAR_STEM} VAR_STEM_UC)
  list(LENGTH CVV_UNPARSED_ARGUMENTS num_versions)
  if (CVV_LIST OR num_versions GREATER 1)
    set(list_suffix _LIST)
  else()
    set(list_suffix)
  endif()
  string(REPLACE ";" " " versions "${CVV_UNPARSED_ARGUMENTS}")
  set(${VAR_STEM_UC}_VERSION${list_suffix} "${versions}" PARENT_SCOPE)
  set(dot_versions)
  foreach(VERSION ${CVV_UNPARSED_ARGUMENTS})
    string(REPLACE "_" "." VDOT "${VERSION}")
    string(REGEX REPLACE "^v" "" VDOT "${VDOT}")
    list(APPEND dot_versions ${VDOT})
  endforeach()
  string(REPLACE ";" " " dot_versions "${dot_versions}")
  set(${VAR_STEM_UC}_DOT_VERSION${list_suffix}
    "${dot_versions}" PARENT_SCOPE)
  if (NOT CVV_NAME)
    set(CVV_NAME "${VAR_STEM}")
  endif()
  set(${VAR_STEM_UC}_NAME "${CVV_NAME}" PARENT_SCOPE)
  if (CVV_QUALIFIERS)
    set(${VAR_STEM_UC}_QUAL "${CVV_QUALIFIERS}" PARENT_SCOPE)
  endif()
endfunction()

function(create_product_variables PRODUCT VERSION)
  message(WARNING "create_product_variables() is obsolete: "
    "use create_version_variables() instead")
  _verify_before_init_shell_fragment_vars(
    "create_product_variables(${ARGV})")
  create_version_variables(${PRODUCT} ${VERSION})
  string(TOUPPER ${PRODUCT} PRODUCT_UC)
  set(${PRODUCT_UC}_VERSION ${${PRODUCT_UC}_VERSION} PARENT_SCOPE)
  set(${PRODUCT_UC}_DOT_VERSION ${${PRODUCT_UC}_DOT_VERSION}
    PARENT_SCOPE)
endfunction()

function(create_product_variable_list PRODUCT VERSION)
  message(WARNING "create_product_variable_list() is obsolete: "
    "use create_version_variables() instead")
  _verify_before_init_shell_fragment_vars(
    "create_product_variable_list(${ARGV})")
  create_version_variables(${PRODUCT} ${VERSION} ${ARGN})
  string(TOUPPER ${PRODUCT} PRODUCT_UC)
  set(${PRODUCT_UC}_VERSION_LIST ${${PRODUCT_UC}_VERSION_LIST}
    PARENT_SCOPE)
  if (${PRODUCT_UC}_QUAL)
    set(${PRODUCT_UC}_QUAL ${${PRODUCT_UC}_QUAL} PARENT_SCOPE)
  endif()
endfunction()

macro(create_pyqual_variables)
  _verify_before_init_shell_fragment_vars("create_pyqual_variables()")
  if (PYTHON_VERSION)
    if (3.0.0 VERSION_GREATER PYTHON_DOT_VERSION AND PYTHON3_VERSION)
      _create_pyqual(${PYTHON_VERSION} PY2QUAL)
      _create_pyqual(${PYTHON3_VERSION} PY3QUAL)
    else()
      _create_pyqual(${PYTHON_VERSION} PYQUAL)
    endif()
  endif()
endmacro()

function(init_shell_fragment_vars)
  _init_shell_fragment_support_vars()
  # INIT_PYQUAL_VARS supports two cases:
  #
  # 1. where we support both Python 2 and Python 3 via a 'py2' build
  #    label on the distribution, or
  #
  # 2. we have only one Python available.
  set(INIT_PYQUAL_VARS
    "########################################################################
# Set Python-related shell variables appropriately.
")
  if (PY3QUAL OR NOT 3.0.0 VERSION_GREATER PYTHON_DOT_VERSION)
    set(INIT_PYQUAL_VARS "${INIT_PYQUAL_VARS}
${_CHECK_OS_PYTHON3_SUPPORT}
")
  endif()
  set(INIT_PYQUAL_VARS "${INIT_PYQUAL_VARS}
if [[ \${build_label} =~ (^|[-:])py2([-:]|\$) ]]; then")
  if (PY2QUAL AND PY3QUAL)
    set(INIT_PYQUAL_VARS "${INIT_PYQUAL_VARS}
  pyver=${PYTHON_VERSION}
  pyqual=${PY2QUAL}
  pylabel=:py2
else
  pyver=${PYTHON3_VERSION}
  pyqual=${PY3QUAL}
  unset pylabel
fi
")
  else()
    set(INIT_PYQUAL_VARS "${INIT_PYQUAL_VARS}
  echo \"Unsupported build label for this distribution.\" 1>&2
  return 1
fi

pyver=${PYTHON_VERSION}
pyqual=${PYQUAL}
unset pylabel
")
  endif()
  if (PY3QUAL OR NOT 3.0.0 VERSION_GREATER PYTHON_DOT_VERSION)
    set(INIT_PYQUAL_VARS "${INIT_PYQUAL_VARS}

if [[ \"\${pyqual}\" == p3* ]]; then
  check_os_python3_support
fi
")
  endif()
  set(INIT_PYQUAL_VARS "${INIT_PYQUAL_VARS}
########################################################################")
  set(INIT_PYQUAL_VARS "${INIT_PYQUAL_VARS}" PARENT_SCOPE)

  set(BUILD_COMPILERS "if version_greater v5_02_00 \\
v\$(print_version | sed -e 's&^.*[ \\t]\\{1,\\}&&' -e 's&\\.&_&g' ); then
  echo \"Need buildFW 5.02.00 or better.\" 1>&2
  return 1
else
${_BUILD_COMPILERS_DETAIL}
fi
" PARENT_SCOPE)
endfunction()

function(distribution VAR_STEM)
  _verify_after_init_shell_fragment_vars("distribution(${ARGV})")
  cmake_parse_arguments(D "WITH_HTML" "" "" ${ARGN})
  string(TOUPPER ${VAR_STEM} VAR_STEM_UC)
  set(cfg_stem "${${VAR_STEM_UC}_NAME}-cfg")
  set(cfg_version "${${VAR_STEM_UC}_DOT_VERSION}")
  if (NOT cfg_version OR NOT ${VAR_STEM_UC}_NAME)
    message(FATAL_ERROR
      "distribution(${ARGV}) requires ${VAR_STEM_UC}_NAME and "
      "${VAR_STEM_UC}_DOT_VERSION to be set")
  endif()
  # Set DIST_BUILD_SPEC for possible expansion in .in files.
  set(DIST_BUILD_SPEC "${${VAR_STEM_UC}_NAME}-${cfg_version}")
  # Configure distribution -cfg file.
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/${cfg_stem}.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${cfg_stem}-${cfg_version}" @ONLY)
  if (D_WITH_HTML) # Optional: configure HTML.
    set(html_stem "${${VAR_STEM_UC}_NAME}")
    set(html_version "${${VAR_STEM_UC}_VERSION}")
    if (NOT html_version)
      message(FATAL_ERROR
        "distribution(${ARGV}) requires ${VAR_STEM_UC}_VERSION to be set")
    endif()
    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/${html_stem}.html.in"
      "${CMAKE_CURRENT_BINARY_DIR}/${html_stem}-${html_version}.html"
      @ONLY)
  endif()
endfunction()

########################################################################
# Private utility functions and macros.
#########################################################################

function(_create_pyqual VERSION_IN VAR)
  string(REPLACE "_" "" pyqual "${VERSION_IN}")
  string(REGEX REPLACE "^v" "p" pyqual "${pyqual}")
  set(${VAR} ${pyqual} PARENT_SCOPE)
endfunction()

macro(_init_shell_fragment_support_vars)
  set(_CHECK_OS_PYTHON3_SUPPORT
    "# Verify OS support for Python 3.
check_os_python3_support() {
  local flvr5=\$(ups flavor -5)
  if [[ \${flvr5##*-} == sl*6 ]]; then
    if want_unsupported; then
      echo \"INFO: Building unsupported Python3 build on SLF6 due to \\
\\\$CET_BUILD_UNSUPPORTED=\${CET_BUILD_UNSUPPORTED}\" 1>&2
    else
      msg=\"INFO: Python3 builds not supported on SLF6 -- \\
export CET_BUILD_UNSUPPORTED=1 to override.\"
      echo \"\$msg\" 1>&2
      rm -f \"\${manifest}\"
      [[ -d \"\${working_dir}/copyBack\" ]] && \\
        echo \"\${msg}\" > \"\${working_dir}/copyBack/skipping_build\"
      exit 0
    fi
  fi
}
")

  set(_CHECK_BASE_DETAIL
    "if [ \"\${bundle_name}\" = \"build_base\" ]; then
    bf_build_base=1
  fi
")

  set(_BUILD_COMPILERS_DETAIL
    "  function bf_handle_cmake() {
    local cv
    if [ -n \"\${CMAKE_VERSION}\" ]; then
      do_pull -f -n cmake \"\${CMAKE_VERSION}\" || \\
        { local no_binary_download=1
          do_build cmake \"\${CMAKE_VERSION}\"; }
    else
      for cv in ${CMAKE_VERSION_LIST}; do
        do_build cmake \${cv}
      done
    fi
  }
  function bf_build_compilers() {
    # Attempt to pull required_items.
    (( bf_build_base )) || ! maybe_pull_gcc && \\
      { local no_binary_download=1
        maybe_build_gcc; }
    bf_handle_cmake
    (( bf_build_base )) || ! maybe_pull_other_compilers && \\
      { local no_binary_download=1
        maybe_build_other_compilers ${SQLITE_VERSION} \\
        ${PYTHON_VERSION}; }
  }
  ${_CHECK_BASE_DETAIL}
  bf_build_compilers && \\
    unset bf_build_base bf_build_compilers bf_handle_cmake
")
endmacro()

function(_verify_before_init_shell_fragment_vars PREAMBLE)
  if (INIT_PYQUAL_VARS)
    message(FATAL_ERROR "${PREAMBLE}: init_shell_fragment_vars() "
      "called too early")
  endif()
endfunction()

function(_verify_after_init_shell_fragment_vars PREAMBLE)
  if (NOT INIT_PYQUAL_VARS)
    message(FATAL_ERROR "${PREAMBLE}: init_shell_fragment_vars() "
      "called too late")
  endif()
endfunction()

cmake_policy(POP)
