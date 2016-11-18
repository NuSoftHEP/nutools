
# support building for -q xx:noifdh on any system

cet_find_library( IFDH NAMES ifdh PATHS ENV IFDHC_LIB NO_DEFAULT_PATH )
if( IFDH )
  include_directories( $ENV{IFDHC_FQ_DIR}/inc )
else()
  add_definitions(-DNO_IFDH_LIB)
  SET(IFDH "")
endif()

art_make( LIBRARY_NAME EventGeneratorBaseGENIE
          LIB_LIBRARIES ${SIMBASE}
                        ${ART_UTILITIES}
                        ${MF_MESSAGELOGGER}
                        ${MF_UTILITIES}
                        ${FHICLCPP}
                        ${CETLIB}
                        ${GENIE_LIB_LIST}
                        ${DK2NUTREE}
                        ${DK2NUGENIE}
                        ${IFDH}
                        ${ROOT_GEOM}
                        ${ROOT_GEOMPAINTER}
                        ${ROOT_BASIC_LIB_LIST}
          MODULE_LIBRARIES 
                        ${SIMBASE}
                        EventGeneratorBaseGENIE
                        ${ART_FRAMEWORK_CORE}
                        ${ART_FRAMEWORK_PRINCIPAL}
                        ${ART_FRAMEWORK_SERVICES_REGISTRY}
                        ${ART_FRAMEWORK_SERVICES_OPTIONAL}
                        ${ART_FRAMEWORK_SERVICES_OPTIONAL_TFILESERVICE_SERVICE}
                        ${ART_FRAMEWORK_SERVICES_OPTIONAL_RANDOMNUMBERGENERATOR_SERVICE}
          ${ART_FRAMEWORK_IO_PRODUCTMIX}  ## for MixGenieEvents_module
          ${ART_FRAMEWORK_IO_ROOT}  ## for IO_PRODUCTMIX
                        ${ART_PERSISTENCY_COMMON}
                        ${ART_PERSISTENCY_PROVENANCE}
                        ${ART_UTILITIES}
                        ${MF_MESSAGELOGGER}
                        ${MF_UTILITIES}
                        ${FHICLCPP}
                        ${CETLIB}
                        ${GENIE_LIB_LIST}
                        ${CLHEP}
                        ${ROOT_EGPYTHIA6}
                        ${ROOT_BASIC_LIB_LIST}
                        ${ROOT_EG}
)


install_headers()
install_fhicl()
install_source()
