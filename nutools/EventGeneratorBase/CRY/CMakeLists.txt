
find_package(ROOT COMPONENTS Geom GeomPainter Core EG REQUIRED)

## find_library directives
# other dependencies
cet_find_library( CRY NAMES CRY PATHS ENV CRY_LIB NO_DEFAULT_PATH ) ### MIGRATE-ACTION-RECOMMENDED: use of ENV ... may be UPS-dependent ### MIGRATE-ACTION-RECOMMENDED: use cet_find_package() with target semantics for linking
# include search path
include_directories ( $ENV{CRYHOME}/src ) ### MIGRATE-ACTION-RECOMMENDED: use target_link_directories() with target semantics

art_make_library(LIBRARIES
                        CRY
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
