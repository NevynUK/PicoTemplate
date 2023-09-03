#!/bin/sh

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

docker build $SCRIPT_DIR --tag pico-build
