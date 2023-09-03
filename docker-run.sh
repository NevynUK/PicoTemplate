#!/bin/sh

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

docker run --platform linux/amd64 --rm -it -v $PWD:/project -w /project pico-build /bin/bash