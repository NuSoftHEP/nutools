
art_make( LIB_LIBRARIES nusimdata::SimulationBase ### MIGRATE-ACTION-RECOMMENDED: use art_make_library(), art_dictionary(), simple_plugin() with explicit source lists
                        CRY
                        messagefacility::MF_MessageLogger
                        
                        fhiclcpp::fhiclcpp
                        cetlib::cetlib
			cetlib_except::cetlib_except
                        ROOT::Geom
                        ROOT::GeomPainter
			ROOT::EG
                        ${ROOT_BASIC_LIB_LIST} )


install_headers()
install_fhicl()
install_source()
