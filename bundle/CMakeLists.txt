# this is a subset of build-framework
# we supply only the bits needed to create the nu and nulite config files

# define some necessary modules
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap)
include( bootstrapModules )

# define qualifiers
set (version_set s85)
set( cet_qualifier e17 )

create_product_variables(ups v6_0_8)
create_product_variables( mrb           v4_01_00 )
create_product_variables( hub           v2_12_4 )

create_product_variables(python v2_7_15a)
create_product_variables(python3 v3_7_2)

# cetpkgsupport and cetbuildtools are a special case
# include as many versions of cetbuildtools as necessary
create_product_variables(cetpkgsupport v1_14_01)
# only cetbuildtools v5_14_03 and later support ups v6
create_product_variable_list( cetbuildtools
  v7_11_00
  v7_12_01
  v7_13_02
  v7_14_00
  v7_15_01
  )
# Required by TRACE >= v3_14_00.
create_product_variables(cetmodules v1_04_00)

# art_suite
#set(suite_rc_level _rc0)
#set(stack_suffix b) # Reset when no longer needed
create_product_variables(canvas v3_06_01${suite_rc_level})
create_product_variables(canvas_stack ${CANVAS_VERSION}${stack_suffix})

create_product_variables(studio v1_01_00)
create_product_variables(canvas_root_io v1_01_11)
create_product_variables(art v2_13_00${suite_rc_level})
if (suite_rc_level)
  create_product_variables(art_suite ${ART_VERSION})
else()
  create_product_variables(art_suite ${ART_VERSION}${stack_suffix})
endif()
# lite framework
create_product_variables(gallery v1_08_06${suite_rc_level})
create_product_variables(critic v1_03_41)

# Tutorial
create_product_variables(toyExperiment v0_03_27)

create_product_variables(cry v1_7k)
create_product_variables(TRACE v3_14_00)
create_product_variables(artdaq_core v3_04_19)

# geant4
create_product_variables(geant4 v4_10_4_p02ba)
create_product_variables(xerces_c v3_2_0a)
create_product_variables(vecgeom v00_05_01)
create_product_variables(qt v5_10_1a)
create_product_variables(g4abla v3_1)
create_product_variables(g4emlow v7_3)
create_product_variables(g4neutron v4_5)
create_product_variables(g4neutronxs v1_4)
create_product_variables(g4nucleonxs v1_1)
create_product_variables(g4nuclide v2_2)
create_product_variables(g4photon v5_2)
create_product_variables(g4pii v1_3)
create_product_variables(g4radiative v5_2)
create_product_variables(g4surface v2_1_1)
create_product_variables(g4tendl v1_3_2)
create_product_variables(geant4reweight v01_00_09 )

# ifdh
create_product_variables(libwda v2_28_0)
create_product_variables(ifdhc v2_5_6)
create_product_variables(ifdhc_config v2_5_6)
create_product_variables(ifbeam v2_4_4)
create_product_variables(nucondb v2_4_4)
create_product_variables(ifdh_art v2_07_08)

# nu_extras
create_product_variables(cstxsd v4_0_0i)
create_product_variables(pygccxml v1_9_1a)
create_product_variables(genie v3_00_06_p01)
create_product_variables(genie_phyopt v3_00_04)
create_product_variables(genie_xsec v3_00_04a)
create_product_variables(lhapdf v5_9_1k)
create_product_variables(pdfsets v5_9_1b)
create_product_variables(log4cpp v1_1_3b)
create_product_variables(dk2nugenie v01_08_00e)
create_product_variables(dk2nudata v01_08_00a)
create_product_variables(ppfx v02_08)
create_product_variables(nusimdata v1_16_04)
create_product_variables(nuevdb v1_00_02 )
create_product_variables(nug4 v1_02_02_01 )
create_product_variables(nugen v1_06_04 )
#create_product_variables(nurandom v1_03_00 )
create_product_variables(nutools v3_01_06)
create_product_variables(nulite v3_01_06b)

# NOvA
create_product_variables(castxml v0_00_00_f20180122)

########################################################################
# Create PYQUAL and/or PY3QUAL
create_pyqual_variables()


########################################################################
# these files should be copied to scisoft for each release

#nu (NOvA uses nu and nulite)
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/nu-cfg.in
                 ${CMAKE_CURRENT_BINARY_DIR}/nu-cfg-${NULITE_DOT_VERSION} @ONLY )
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/nubase-cfg.in
                 ${CMAKE_CURRENT_BINARY_DIR}/nubase-cfg-${NULITE_DOT_VERSION} @ONLY )
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/nu.html.in
                 ${CMAKE_CURRENT_BINARY_DIR}/nu-${NULITE_VERSION}.html @ONLY )

#nulite (LArSoft only uses nulite)
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/nulite-cfg.in
                 ${CMAKE_CURRENT_BINARY_DIR}/nulite-cfg-${NULITE_DOT_VERSION} @ONLY )
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/nulite_base-cfg.in
                 ${CMAKE_CURRENT_BINARY_DIR}/nulite_base-cfg-${NULITE_DOT_VERSION} @ONLY )
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/nulite.html.in
                 ${CMAKE_CURRENT_BINARY_DIR}/nulite-${NULITE_VERSION}.html @ONLY )
