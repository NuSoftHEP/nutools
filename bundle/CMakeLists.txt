# this is a subset of build-framework
# we supply only the bits needed to create the nu and nulite config files

# define some necessary modules
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap)
include( bootstrapModules )

# define qualifiers
set (version_set s78)
set( cet_qualifier e17 )

create_product_variables(ups v6_0_8)
create_product_variables( mrb           v3_05_03 )
create_product_variables( hub           v2_12_4 )

create_product_variables(python v2_7_14b)

# cetpkgsupport and cetbuildtools are a special case
# include as many versions of cetbuildtools as necessary
create_product_variables(cetpkgsupport v1_14_01)
# only cetbuildtools v5_14_03 and later support ups v6
create_product_variable_list( cetbuildtools
  v7_06_04
  v7_10_00
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
create_product_variables(canvas v3_05_01${suite_rc_level})
create_product_variables(canvas_stack ${CANVAS_VERSION}${stack_suffix})

create_product_variables(studio v1_01_00)
create_product_variables(canvas_root_io v1_02_02)
create_product_variables(art v3_01_02${suite_rc_level})
if (suite_rc_level)
  create_product_variables(art_suite ${ART_VERSION})
else()
  create_product_variables(art_suite ${ART_VERSION}${stack_suffix})
endif()
# lite framework
create_product_variables(gallery v1_11_02${suite_rc_level})
create_product_variables(critic v1_05_02)

# Tutorial
create_product_variables(toyExperiment v0_04_02)

create_product_variables(cry v1_7k)
create_product_variables(TRACE v3_13_11)
create_product_variables(artdaq_core v3_04_10)

# geant4
create_product_variables(geant4 v4_10_3_p03c)
create_product_variables(xerces_c v3_2_0a)
create_product_variables(vecgeom v0_4a)
create_product_variables(qt v5_7_1a)
create_product_variables(g4abla v3_0)
create_product_variables(g4emlow v6_50)
create_product_variables(g4neutron v4_5)
create_product_variables(g4neutronxs v1_4)
create_product_variables(g4nucleonxs v1_1)
create_product_variables(g4nuclide v2_1)
create_product_variables(g4photon v4_3_2)
create_product_variables(g4pii v1_3)
create_product_variables(g4radiative v5_1_1)
create_product_variables(g4surface v1_0)
create_product_variables(g4tendl v1_3)
create_product_variables(geant4reweight v01_00_03c )

# ifdh
create_product_variables(libwda v2_30_0)
create_product_variables(ifdhc v2_6_7a)
create_product_variables(ifdhc_config v2_6_7)
create_product_variables(ifbeam v2_5_13a)
create_product_variables(nucondb v2_5_13a)
create_product_variables(ifdh_art v2_07_09)

# nu_extras
create_product_variables(cstxsd v4_0_0h)
create_product_variables(pygccxml v1_9_1)
create_product_variables(genie v3_00_04_ub3)
create_product_variables(genie_phyopt v3_00_04)
create_product_variables(genie_xsec v3_00_04_ub2)
create_product_variables(lhapdf v5_9_1k)
create_product_variables(pdfsets v5_9_1b)
create_product_variables(log4cpp v1_1_3a)
create_product_variables(dk2nugenie v01_08_00_ub3)
create_product_variables(dk2nudata v01_08_00)
create_product_variables(ppfx v02_11_02)
create_product_variables(nusimdata v1_15_05)
create_product_variables(nutools v2_27_09)
create_product_variables(nulite v2_27_09)

# NOvA
create_product_variables(castxml v0_00_00_f20180122)

########################################################################
# Create PYQUAL and/or PY3QUAL
create_pyqual_variables()


########################################################################
# these files should be copied to scisoft for each release

#nulite (LArSoft only uses nulite)
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/nulite-cfg.in
                 ${CMAKE_CURRENT_BINARY_DIR}/nulite-cfg-${NULITE_DOT_VERSION} @ONLY )
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/nulite_base-cfg.in
                 ${CMAKE_CURRENT_BINARY_DIR}/nulite_base-cfg-${NULITE_DOT_VERSION} @ONLY )
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/nulite.html.in
                 ${CMAKE_CURRENT_BINARY_DIR}/nulite-${NULITE_VERSION}.html @ONLY )
