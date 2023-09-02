#!/bin/bash

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

#
#   Flash the board with openocd
#
echo "Flashing project binaries using OpenOCD..."

OPENOCD_DIR=$PICO_SDK_PATH/../openocd/
$OPENOCD_DIR/src/openocd -s $OPENOCD_DIR/tcl -f interface/cmsis-dap.cfg -f target/rp2040.cfg -c "adapter speed 5000" -s tcl -c "program $SCRIPT_DIR/build/projectname.elf verify reset exit"