# installing scripts into a tools directory
macro( _nu_install_tools )
  cmake_parse_arguments( NT "" "DIRNAME" "SCRIPT_LIST" ${ARGN})
  if( NT_DIRNAME )
    install( PROGRAMS ${NT_SCRIPT_LIST}
             DESTINATION "${PROJECT_NAME}/${PROJECT_VERSION}/tools/${NT_DIRNAME}" )
  else()
    install( PROGRAMS ${NT_SCRIPT_LIST}
             DESTINATION "${PROJECT_NAME}/${PROJECT_VERSION}/tools" )
  endif()
endmacro( _nu_install_tools )

add_subdirectory (refactor)
add_subdirectory (nutools3)

# This is for users NOT using mrb or cetbuildtools in their build system
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/setup_cetbuildtools.csh.in
                 ${CMAKE_CURRENT_BINARY_DIR}/setup_cetbuildtools.csh @ONLY )
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/setup_cetbuildtools.sh.in
                 ${CMAKE_CURRENT_BINARY_DIR}/setup_cetbuildtools.sh @ONLY )
install_scripts( LIST ${CMAKE_CURRENT_BINARY_DIR}/setup_cetbuildtools.csh ${CMAKE_CURRENT_BINARY_DIR}/setup_cetbuildtools.sh )
