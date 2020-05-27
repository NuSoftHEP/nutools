# this is a subset of build-framework
# we supply only the bits needed to create the nu and nulite config files

# define some necessary modules
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap)
include( bootstrapModules )

# define qualifiers
set (version_set s97)
set( cet_qualifier e19 )

create_product_variables(ups v6_0_8)

create_product_variables(python v2_7_15a)
create_product_variables(python3 v3_7_2)

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
set(stack_suffix) # Reset when no longer needed
create_product_variables(canvas v3_09_01${suite_rc_level})
create_product_variables(canvas_stack ${CANVAS_VERSION}${stack_suffix})
create_product_variables(studio v1_02_00)
create_product_variables(canvas_root_io v1_05_02)
create_product_variables(art v3_05_01${suite_rc_level})

create_product_variables(art_suite ${ART_VERSION})
create_product_variables(art_root_io v1_03_01)

# lite framework
create_product_variables(gallery v1_14_02${suite_rc_level})

# Tutorial
create_product_variables(toyExperiment v0_05_03)

create_product_variables(cry v1_7m)
create_product_variables(TRACE v3_15_07)
create_product_variables(artdaq_core v3_05_15)

# geant4
create_product_variables(geant4 v4_10_3_p03e)
create_product_variables(xerces_c v3_2_2)
create_product_variables(vecgeom v00_05_01)
create_product_variables(qt v5_12_3)
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
create_product_variables(geant4reweight v01_02_00)

# ifdh
create_product_variables(libwda v2_28_0)
create_product_variables(ifdhc v2_5_6)
create_product_variables(ifdhc_config v2_5_6)
create_product_variables(ifbeam v2_4_4)
create_product_variables(nucondb v2_4_4)
create_product_variables(ifdh_art v2_10_06)

# nu_extras
create_product_variables(cstxsd v4_0_0h)
create_product_variables(pygccxml v1_9_1)
create_product_variables(genie v3_00_06h)
create_product_variables(genie_phyopt v3_00_04)
create_product_variables(genie_xsec v3_00_04a)
create_product_variables(lhapdf v6_2_3d)
create_product_variables(log4cpp v1_1_3b)
create_product_variables(dk2nugenie v01_08_00k)
create_product_variables(dk2nudata v01_08_00g)
create_product_variables(ppfx v02_03)

# tauola and friends
create_product_variables(hepmc3 v3_2_1a)
create_product_variables(pythia8 v8_3_02)
create_product_variables(tauola v1_1_8b)

create_product_variables(nusimdata v1_21_02)
create_product_variables(nuevdb v1_02_05)
create_product_variables(nug4 v1_04_03)
create_product_variables(nugen v1_10_07)
create_product_variables(nurandom v1_04_03)

set(nulite_suffix b) # Reset when no longer needed
create_product_variables(nutools v3_06_05)
create_product_variables(nulite ${NUTOOLS_VERSION}${nulite_suffix})

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

#ifdh
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/ifdh-cfg.in
                 ${CMAKE_CURRENT_BINARY_DIR}/ifdh-cfg-${IFDH_ART_DOT_VERSION} @ONLY )
