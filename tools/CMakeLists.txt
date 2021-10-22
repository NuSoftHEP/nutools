# installing scripts into a tools directory
macro( _nu_install_tools )
  cmake_parse_arguments( NT "" "DIRNAME" "SCRIPT_LIST" ${ARGN})
  if( NT_DIRNAME )
    install( PROGRAMS ${NT_SCRIPT_LIST}
             DESTINATION "tools/${NT_DIRNAME}" )
  else()
    install( PROGRAMS ${NT_SCRIPT_LIST}
             DESTINATION "tools" )
  endif()
endmacro( _nu_install_tools )

add_subdirectory (refactor)
add_subdirectory (nutools3)

