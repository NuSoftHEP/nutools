use strict;

use vars qw(%dir_list);
BEGIN { %dir_list = (
  "G4EVENT" => "Geant4::G4event",
  "G4GEOMETRY" => "Geant4::G4geometry",
  "G4GLOBAL" => "Geant4::G4global",
  "G4INTERCOMS" => "Geant4::G4intercoms",
  "G4MATERIALS" => "Geant4::G4materials",
  "G4MODELING" => "Geant4::G4modeling",
  "G4PARTICLES" => "Geant4::G4particles",
  "G4PERSISTENCY" => "Geant4::G4persistency",
  "G4PHYSICSLISTS" => "Geant4::G4physicslists",
  "G4PROCESSES" => "Geant4::G4processes",
  "G4READOUT" => "Geant4::G4readout",
  "G4RUN" => "Geant4::G4run",
  "G4TRACKING" => "Geant4::G4tracking",
  "G4FR" => "Geant4::G4FR",
  "G4GMOCREN" => "Geant4::G4GMocren",
  "G4RAYTRACER" => "Geant4::G4RayTracer",
  "G4TREE" => "Geant4::G4Tree",
  "G4VRML" => "Geant4::G4VRML",
  "G4VISHEPREP" => "Geant4::G4visHepRep",
  "G4VIS_MANAGEMENT" => "Geant4::G4vis_management",
  "XERCESC" => "XercesC::XercesC"
                       ); }

foreach my $lib (sort keys %dir_list) {
   next if m&add_subdirectory&i;
   next if m&find_ups_product&i;
   next if m&simple_plugin&i;
   next if m&create_version_variables&i;
   next if m&SUBDIRNAME&i;
   next if m&SUBDIRS&i;
   next if m&LIBRARY_NAME&i;
   next if m&PACKAGE&i;
   next if m&fhiclcpp::fhiclcpp&i;
   next if m&canvas::canvas&i;
   next if m&cetlib::cetlib&i;
   next if m&cetlib_except::cetlib_except&i;
   next if m&messagefacility::MF&i;
  #s&\b\Q${lib}\E([^\.\s]*\b)([^\.]|$)&$dir_list{$lib}${1}${2}&g and last;
  s&\b\Q${lib}\E\b([^\.]|$)&$dir_list{$lib}${1}${2}&g and last;
}

s&\$\{G4FR\}&G4FR&;
s&\$\{G4GMOCREN\}&G4GMOCREN&;
s&\$\{G4RAYTRACER\}&G4RAYTRACER&;
s&\$\{G4TREE\}&G4TREE&;
s&\$\{G4VRML\}&G4VRML&;
s&\$\{G4EVENT\}&G4EVENT&;
s&\$\{G4GEOMETRY\}&G4GEOMETRY&;
s&\$\{G4GLOBAL\}&G4GLOBAL&;
s&\$\{G4INTERCOMS\}&G4INTERCOMS&;
s&\$\{G4MATERIALS\}&G4MATERIALS&;
s&\$\{G4MODELING\}&G4MODELING&;
s&\$\{G4PARTICLES\}&G4PARTICLES&;
s&\$\{G4PERSISTENCY\}&G4PERSISTENCY&;
s&\$\{G4PHYSICSLISTS\}&G4PHYSICSLISTS&;
s&\$\{G4PROCESSES\}&G4PROCESSES&;
s&\$\{G4READOUT\}&G4READOUT&;
s&\$\{G4RUN\}&G4RUN&;
s&\$\{G4TRACKING\}&G4TRACKING&;
s&\$\{G4VISHEPREP\}&G4VISHEPREP&;
s&\$\{G4VIS_MANAGEMENT\}&G4VIS_MANAGEMENT&;
s&\$\{XERCESC\}&XERCESC&;
