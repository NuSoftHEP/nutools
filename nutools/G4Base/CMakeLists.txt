include(${Geant4_USE_FILE})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${Geant4_CXX_FLAGS} -Wno-shadow")
art_make( LIB_LIBRARIES nusimdata_SimulationBase
                        nutools_MagneticField_MagneticField_service
			canvas
                        ${MF_MESSAGELOGGER}
                        ${MF_UTILITIES}
                        ${FHICLCPP}
                        cetlib
                        ${Geant4_LIBRARIES}
                        )

install_headers()
install_fhicl()
install_source()
