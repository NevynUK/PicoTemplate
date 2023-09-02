#!/bin/sh

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

HELP=false
for i in "$@"
do
case $i in
    -h|--help)
    HELP=true
    ;;
    -r|--rebuild)
    make -C $SCRIPT_DIR/build clean
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
    echo "-h | --help             Display this message"
    echo "-r | --rebuild          Remove any built objects and rebuild the project."
    exit 0
fi

cd $SCRIPT_DIR/build && make 
