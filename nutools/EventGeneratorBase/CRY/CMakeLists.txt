
art_make( LIB_LIBRARIES nusimdata_SimulationBase
                        CRY
                        messagefacility::MF_MessageLogger
                        ${MF_UTILITIES}
                        fhiclcpp::fhiclcpp
                        cetlib::cetlib
			cetlib_except::cetlib_except
                        ${ROOT_GEOM}
                        ${ROOT_GEOMPAINTER}
			${ROOT_EG}
                        ${ROOT_BASIC_LIB_LIST} )


install_headers()
install_fhicl()
install_source()
