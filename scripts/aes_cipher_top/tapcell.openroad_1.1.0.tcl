#===========================================================
#   set environment variable
#===========================================================
source ../../scripts/common/set_env.tcl

#===========================================================
#   set tool related parameter
#===========================================================
if { [string equal $TRACK "HS"] == 1 } {
    puts $TRACK
    set TAP_CELL     "sky130_fd_sc_hs__tap_1"
    set ENDCAP       "sky130_fd_sc_hs__fill_1"
} elseif { [string equal $TRACK "HD"] == 1 } {
    puts $TRACK
    set TAP_CELL     "sky130_fd_sc_hd__tapvpwrvgnd_1"
    set ENDCAP       "sky130_fd_sc_hd__decap_4"
}

#===========================================================
#   main running
#===========================================================
# Read lef
foreach lef $LEF_FILES {
    read_lef $lef
}

# Read liberty files
foreach libFile $LIB_FILES {
    read_liberty $libFile
}

# Read def files
read_def $PRE_RESULT_PATH/$DESIGN.def

tapcell \
  -endcap_cpp "2" \
  -distance 14 \
  -tapcell_master $TAP_CELL \
  -endcap_master $ENDCAP

# write output
write_def       $RESULT_PATH/$DESIGN.def
write_verilog   $RESULT_PATH/$DESIGN.v
exit

