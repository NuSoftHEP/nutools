
art_make( EventGeneratorBasetest
          MODULE_LIBRARIES ${SIMBASE}
                           EventGeneratorBaseCRY
                           EventGeneratorBaseGENIE
                        ${ART_FRAMEWORK_SERVICES_OPTIONAL_RANDOMNUMBERGENERATOR_SERVICE}
                        ${MF_MESSAGELOGGER}
                        ${MF_UTILITIES}
                        ${FHICLCPP}
                        ${CETLIB}
                        ${GENIE_LIB_LIST}
                        ${CRY}
                        ${ROOT_CORE}
                        ${ROOT_CINT}
                        ${ROOT_RIO}
                        ${ROOT_NET}
                        ${ROOT_HIST}
                        ${ROOT_GRAF}
                        ${ROOT_GRAF3D}
                        ${ROOT_GPAD}
                        ${ROOT_TREE}
                        ${ROOT_RINT}
                        ${ROOT_POSTSCRIPT}
                        ${ROOT_MATRIX}
                        ${ROOT_PHYSICS}
                        ${ROOT_MATHCORE}
                        ${ROOT_THREAD}
                        ${ROOT_EG}
                        ${ROOT_TREEPLAYER}
                        ${ROOT_FFTW}
                        ${ROOT_REFLEX}
                        ${ROOTSYS}/lib/libEGPythia6.so
                        ${ROOT_GUI}
                        )

install_headers()
install_fhicl()
install_source()
install(FILES README DESTINATION ${product}/${version}/source/${CURRENT_SUBDIR} )
