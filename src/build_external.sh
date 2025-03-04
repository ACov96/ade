#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

pushd $SCRIPT_DIR/../external

pushd dwm
git clean -xdf
make clean install
popd

pushd dmenu
git clean -xdf
make clean install
popd

pushd st
git clean -xdf
make clean install
popd

pushd tabbed
git clean -xdf
make clean install
popd

popd
