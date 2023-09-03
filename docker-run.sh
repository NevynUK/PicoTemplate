#!/bin/sh

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

docker run --rm -it -v $PWD:/project -w /project pico-build /bin/bash