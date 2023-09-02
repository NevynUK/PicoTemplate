#!/bin/sh

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

HELP=false
PROJECT_NAME=
for i in "$@"
do
case $i in
    -h|--help)
    HELP=true
    ;;
    -n=*|--name=*)
    PROJECT_NAME="${i#*=}"
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
    exit 0
fi

if [ -z "$PROJECT_NAME" ]; then
    echo "No project name specified."
    exit 1
fi

#
#   Change the project and binary file names in CMakeLists.txt and flash.sh
#
sed -i.bak "s/projectname/$PROJECT_NAME/g" $SCRIPT_DIR/CMakeLists.txt
sed -i.bak "s/projectname/$PROJECT_NAME/g" $SCRIPT_DIR/flash.sh
sed -i.bak "s/projectname/$PROJECT_NAME/g" $SCRIPT_DIR/.vscode/launch.json

rm $SCRIPT_DIR/*.bak
rm $SCRIPT_DIR/.vscode/*.bak

cmake -S . -B $SCRIPT_DIR/build
