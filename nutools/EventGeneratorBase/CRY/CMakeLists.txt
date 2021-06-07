
art_make( LIB_LIBRARIES nusimdata_SimulationBase
                        ${CRY}
                        ${MF_MESSAGELOGGER}
                        ${MF_UTILITIES}
                        ${FHICLCPP}
                        cetlib
                        cetlib_except
                        ${ROOT_Geom_LIBRARY}
                        ${ROOT_GeomPainter_LIBRARY}
                        ${ROOT_EG_LIBRARY}
                        ${ROOT_LIBRARIES} )


install_headers()
install_fhicl()
install_source()
