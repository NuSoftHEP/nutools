set( PACKAGE IFDatabase )
FILE( GLOB src_files *.cpp )

cet_find_library( LIBWDA NAMES wda PATHS ${CMAKE_INSTALL_RPATH} NO_DEFAULT_PATH )
cet_find_library( PQ NAMES pq PATHS ${CMAKE_INSTALL_RPATH} NO_DEFAULT_PATH )
find_library( CURL NAMES curl )

include_directories( ${LIBWDA_INC} )

art_make_library( SOURCE ${src_files} #${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE}Cint.cc
                  LIBRARIES     ${LIBWDA}
                                ${Boost_DATE_TIME_LIBRARY}
                                ${Boost_SYSTEM_LIBRARY}
                                ${Boost_FILESYSTEM_LIBRARY}
                                ${Boost_THREAD_LIBRARY}
                                ${Boost_REGEX_LIBRARY}
                                ${XCLIB}
                                ${PQ}
                                ${CURL}
                 )

art_make_exec( NAME tagConditionsTableInDB
               SOURCE tagConditionsTableInDB.cc
               LIBRARIES nutools_IFDatabase
                         ${CURL}
               )

art_make_exec( NAME writeConditionsCSVToDB.cc
               SOURCE writeConditionsCSVToDB.cc
               LIBRARIES nutools_IFDatabase
                         ${CURL}
               )

art_make_exec( NAME dumpConditionsToCSV
               SOURCE dumpConditionsToCSV.cc
               LIBRARIES nutools_IFDatabase
                         ${CURL}
               )

simple_plugin( DBI "service"
               nutools_EventDisplayBase
               nutools_IFDatabase
               ${ART_FRAMEWORK_CORE}
               ${ART_FRAMEWORK_PRINCIPAL}
               ${ART_FRAMEWORK_SERVICES_REGISTRY}
               ${ART_FRAMEWORK_SERVICES_BASIC}
               art_Persistency_Common
               art_Utilities
               canvas
               ${MF_MESSAGELOGGER}
               ${MF_UTILITIES}
               ${FHICLCPP}
               cetlib
               cetlib_except
             )

install_headers()
install_fhicl()
install_source()
