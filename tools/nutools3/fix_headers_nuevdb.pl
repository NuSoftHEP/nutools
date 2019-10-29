use strict;

use vars qw(%subdir_list);
use vars qw(%header_list);

# explicit headers to avoid conflicts with experiment code
BEGIN { %header_list = (
"nutools/EventDisplayBase/ButtonBar.h"=> "nuevdb/EventDisplayBase/ButtonBar.h",
"nutools/EventDisplayBase/Canvas.h"=> "nuevdb/EventDisplayBase/Canvas.h",
"nutools/EventDisplayBase/ColorScale.h"=> "nuevdb/EventDisplayBase/ColorScale.h",
"nutools/EventDisplayBase/Colors.h"=> "nuevdb/EventDisplayBase/Colors.h",
"nutools/EventDisplayBase/DisplayWindow.h"=> "nuevdb/EventDisplayBase/DisplayWindow.h",
"nutools/EventDisplayBase/EditMenu.h"=> "nuevdb/EventDisplayBase/EditMenu.h",
"nutools/EventDisplayBase/evdb.h"=> "nuevdb/EventDisplayBase/evdb.h",
"nutools/EventDisplayBase/EventDisplay.h"=> "nuevdb/EventDisplayBase/EventDisplay.h",
"nutools/EventDisplayBase/EventHolder.h"=> "nuevdb/EventDisplayBase/EventHolder.h",
"nutools/EventDisplayBase/FileMenu.h"=> "nuevdb/EventDisplayBase/FileMenu.h",
"nutools/EventDisplayBase/Functors.h"=> "nuevdb/EventDisplayBase/Functors.h",
"nutools/EventDisplayBase/HelpMenu.h"=> "nuevdb/EventDisplayBase/HelpMenu.h",
"nutools/EventDisplayBase/JobMenu.h"=> "nuevdb/EventDisplayBase/JobMenu.h",
"nutools/EventDisplayBase/LinkDef.h"=> "nuevdb/EventDisplayBase/LinkDef.h",
"nutools/EventDisplayBase/ListWindow.h"=> "nuevdb/EventDisplayBase/ListWindow.h",
"nutools/EventDisplayBase/MenuBar.h"=> "nuevdb/EventDisplayBase/MenuBar.h",
"nutools/EventDisplayBase/NavState.h"=> "nuevdb/EventDisplayBase/NavState.h",
"nutools/EventDisplayBase/ObjListCanvas.h"=> "nuevdb/EventDisplayBase/ObjListCanvas.h",
"nutools/EventDisplayBase/ParameterSetEditDialog.h"=> "nuevdb/EventDisplayBase/ParameterSetEditDialog.h",
"nutools/EventDisplayBase/ParameterSetEdit.h"=> "nuevdb/EventDisplayBase/ParameterSetEdit.h",
"nutools/EventDisplayBase/Printable.h"=> "nuevdb/EventDisplayBase/Printable.h",
"nutools/EventDisplayBase/PrintDialog.h"=> "nuevdb/EventDisplayBase/PrintDialog.h",
"nutools/EventDisplayBase/Reconfigurable.h"=> "nuevdb/EventDisplayBase/Reconfigurable.h",
"nutools/EventDisplayBase/RootEnv.h"=> "nuevdb/EventDisplayBase/RootEnv.h",
"nutools/EventDisplayBase/ScanOptions.h"=> "nuevdb/EventDisplayBase/ScanOptions.h",
"nutools/EventDisplayBase/ScanWindow.h"=> "nuevdb/EventDisplayBase/ScanWindow.h",
"nutools/EventDisplayBase/ServiceTable.h"=> "nuevdb/EventDisplayBase/ServiceTable.h",
"nutools/EventDisplayBase/StatusBar.h"=> "nuevdb/EventDisplayBase/StatusBar.h",
"nutools/EventDisplayBase/View2D.h"=> "nuevdb/EventDisplayBase/View2D.h",
"nutools/EventDisplayBase/View3D.h"=> "nuevdb/EventDisplayBase/View3D.h",
"nutools/EventDisplayBase/WindowMenu.h"=> "nuevdb/EventDisplayBase/WindowMenu.h",
"nutools/IFDatabase/ColumnDef.h"=> "nuevdb/IFDatabase/ColumnDef.h",
"nutools/IFDatabase/Column.h"=> "nuevdb/IFDatabase/Column.h",
"nutools/IFDatabase/DataType.h"=> "nuevdb/IFDatabase/DataType.h",
"nutools/IFDatabase/DBIService.h"=> "nuevdb/IFDatabase/DBIService.h",
"nutools/IFDatabase/Row.h"=> "nuevdb/IFDatabase/Row.h",
"nutools/IFDatabase/Table.h"=> "nuevdb/IFDatabase/Table.h",
"nutools/IFDatabase/Util.h"=> "nuevdb/IFDatabase/Util.h"
		       ); }

foreach my $inc (sort keys %header_list) {
  s&^(\s*#include\s+["<])\Q$inc\E(.*)&${1}$header_list{$inc}${2}& and last;
}
