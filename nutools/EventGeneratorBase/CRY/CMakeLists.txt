
find_package(ROOT COMPONENTS Geom GeomPainter Core EG REQUIRED)
find_package(CRY)

art_make_library(LIBRARIES PRIVATE
                        CRY::CRY
                        nusimdata::SimulationBase
                        art::Framework_Services_Registry
                        messagefacility::MF_MessageLogger
                        fhiclcpp::fhiclcpp
                        cetlib::cetlib
			cetlib_except::cetlib_except
                        ROOT::Geom
                        ROOT::GeomPainter
			ROOT::EG
                        ROOT::Core
                        CLHEP::CLHEP
                        )

install_headers()
install_fhicl()
install_source()
