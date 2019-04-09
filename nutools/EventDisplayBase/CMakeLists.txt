
set( PACKAGE EventDisplayBase )
FILE( GLOB src_files *.cxx )

set( EVD_LIBS ${ART_FRAMEWORK_SERVICES_REGISTRY}
              ${ART_FRAMEWORK_CORE}
              art_Persistency_Common
              ${ART_FRAMEWORK_IO_SOURCES}
              ${ART_ROOT_IO}
              ${ART_ROOT_IO_ROOTINPUT_SOURCE}
              ${ART_FRAMEWORK_PRINCIPAL}
              art_Persistency_Provenance
              art_Utilities
	      canvas
              ${MF_MESSAGELOGGER}
              ${MF_UTILITIES}
              ${FHICLCPP}
              cetlib
	      cetlib_except
              ${Boost_SYSTEM_LIBRARY}
              ${ROOT_Eve_LIBRARY}
              ${ROOT_EG_LIBRARY}
              ${ROOT_GX11_LIBRARY}
              ${ROOT_TreePlayer_LIBRARY}
              ${ROOT_Geom_LIBRARY}
              ${ROOT_Ged_LIBRARY}
              ${ROOT_RGL_LIBRARY}
              ${ROOT_Gui_LIBRARY}
              ${ROOT_Core_LIBRARY}
              ${ROOT_Cling_LIBRARY}
              ${ROOT_RIO_LIBRARY}
              ${ROOT_Net_LIBRARY}
              ${ROOT_Hist_LIBRARY}
              ${ROOT_Graf_LIBRARY}
              ${ROOT_Graf3d_LIBRARY}
              ${ROOT_Gpad_LIBRARY}
              ${ROOT_Tree_LIBRARY}
              ${ROOT_Rint_LIBRARY}
              ${ROOT_Postscript_LIBRARY}
              ${ROOT_Matrix_LIBRARY}
              ${ROOT_Physics_LIBRARY}
              ${ROOT_MathCore_LIBRARY}
              ${ROOT_Thread_LIBRARY}
              ${ROOT_LIBRARIES})

cet_rootcint( ${PACKAGE} )

art_make_library( SOURCE ${src_files} ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE}Cint.cc
                  LIBRARIES nusimdata_SimulationBase ${EVD_LIBS} )

set( EVD_SERVICE_LIBS nutools_EventDisplayBase ${EVD_LIBS} )
simple_plugin( EventDisplay service ${EVD_SERVICE_LIBS} )
simple_plugin( ScanOptions  service ${EVD_SERVICE_LIBS} )
simple_plugin( Colors       service ${EVD_SERVICE_LIBS} )

install_headers()
install_fhicl()
install_source()
