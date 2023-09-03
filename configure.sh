#!/bin/sh

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

HELP=false
PROJECT_NAME=
BOARD=
for i in "$@"
do
case $i in
    -h|--help)
    HELP=true
    ;;
    -n=*|--name=*)
    PROJECT_NAME="${i#*=}"
    ;;
    -b=*|--board=*)
    BOARD="${i#*=}"
    ;;
    *)
    echo "${0##*/} - Unknown option $i"
    exit 1
    ;;
esac
done

if $HELP; then
    echo "Usage: ${0##*/} [-h|--help] [-r|--rebuild]"
    echo ""
    echo "Options:"
    echo "-h | --help                               Display this message"
    echo "-n=project_name | --name=project_name     Set the project name in CMakeFileList.txt and flash.sh."
    echo "-b=pico|picow | --board=pico|picow        Specify the board to be used, no board type uses the repository default."
    exit 0
fi

#
#   Check if we have a project name.
#
if [ -z "$PROJECT_NAME" ]; then
    echo "No project name specified, using default name 'PicoApp'."
    PROJECT_NAME='PicoApp'
fi

#
#   See if we have a board type.
#
if [ -z "$BOARD" ]; then
    echo "No board type specified, using repository default (pico)."
    BOARD=pico
fi
CMAKE_FLAGS=
if [ "$BOARD" = "pico" ]; then
    echo "Using Raspberry Pi Pico board."
    CMAKE_FLAGS="-DPICO_BOARD=pico"
elif [ "$BOARD" = "picow" ]; then
    echo "Using Raspberry Pi Pico W (WiFi and Bluetooth) board."
    CMAKE_FLAGS="-DPICO_BOARD=pico_w"
else
    echo "Unknown board type $BOARD."
    exit 1
fi
cp -f $SCRIPT_DIR/templates/$BOARD/CMakeLists.txt $SCRIPT_DIR/CMakeLists.txt
cp -f $SCRIPT_DIR/templates/$BOARD/main.cpp $SCRIPT_DIR/src/main.cpp

#
#   Change the project and binary file names in CMakeLists.txt, flash.sh and VS Code launch.json files.
#
sed -i.bak "s/projectname/$PROJECT_NAME/g" $SCRIPT_DIR/CMakeLists.txt
sed -i.bak "s/projectname/$PROJECT_NAME/g" $SCRIPT_DIR/flash.sh
sed -i.bak "s/projectname/$PROJECT_NAME/g" $SCRIPT_DIR/.vscode/launch.json

rm $SCRIPT_DIR/*.bak
rm $SCRIPT_DIR/.vscode/*.bak

cmake $CMAKE_FLAGS -S . -B $SCRIPT_DIR/build
