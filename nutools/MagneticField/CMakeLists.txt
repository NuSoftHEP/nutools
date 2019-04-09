
simple_plugin( MagneticField service
               ${MF_MESSAGELOGGER}
               ${MF_UTILITIES}
	       cetlib_except
               ${CLHEP_LIBRARIES}
               ${ROOT_LIBRARIES}
               ${ROOT_Geom_LIBRARY}
               ${ROOT_GeomPainter_LIBRARY}
               )


install_headers()
install_fhicl()
install_source()
