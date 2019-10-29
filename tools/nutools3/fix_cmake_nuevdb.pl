use strict;

use vars qw(%dir_list);
BEGIN { %dir_list = (
        "nutools_EventDisplayBase_Colors_service" => "nuevdb_EventDisplayBase_Colors_service",
        "nutools_EventDisplayBase_EventDisplay_service" => "nuevdb_EventDisplayBase_EventDisplay_service",
        "nutools_EventDisplayBase_ScanOptions_service" => "nuevdb_EventDisplayBase_ScanOptions_service",
        "nutools_EventDisplayBase" => "nuevdb_EventDisplayBase",
        "nutools_IFDatabase" => "nuevdb_IFDatabase",
        "nutools_IFDatabase_DBI_service" => "nuevdb_IFDatabase_DBI_service"
                       ); }

foreach my $lib (sort keys %dir_list) {
   next if m&add_subdirectory&i;
   next if m&simple_plugin&i;
   next if m&SUBDIRNAME&i;
   next if m&SUBDIRS&i;
  #s&\b\Q${lib}\E([^\.\s]*\b)([^\.]|$)&$dir_list{$lib}${1}${2}&g and last;
  s&\b\Q${lib}\E\b([^\.]|$)&$dir_list{$lib}${1}${2}&g and last;
}
