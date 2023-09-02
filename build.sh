#!/bin/sh

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

clean() {
    make -j -C $SCRIPT_DIR/build clean
    rm -R $SCRIPT_DIR/build/*
    cmake -S . -B $SCRIPT_DIR/build
}

HELP=false
DEBUG=false
RELEASE=false
for i in "$@"
do
case $i in
    -h|--help)
    HELP=true
    ;;
    -c|--clean)
    clean
    ;;
    -d|--debug)
    if $RELEASE; then
        echo "Cannot build both debug and release versions."
        exit 1
    fi
    DEBUG=true
    ;;
    --release)
    if $DEBUG; then
        echo "Cannot build both debug and release versions."
        exit 1
    fi
    RELEASE=true
    ;;
    -r|--rebuild)
    clean
    ;;
    *)
    echo "${0##*/} - Unknown option $i"
    exit 1
    ;;
esac
done

if $HELP; then
    echo "Usage: ${0##*/}"
    echo ""
    echo "Options:"
    echo "-h | --help             Display this message"
    echo "-c | --clean            Clean the build directory"
    echo "-d | --debug            Build a debug version of the application"
    echo "--release               Build a release version of the application"
    echo "-r | --rebuild          Remove any built objects and rebuild the project"
    exit 0
fi

if $DEBUG; then
    cmake -DCMAKE_BUILD_TYPE=Debug -S . -B $SCRIPT_DIR/build
fi

if $RELEASE; then
    cmake -S . -B $SCRIPT_DIR/build
fi

make -j -C $SCRIPT_DIR/build
