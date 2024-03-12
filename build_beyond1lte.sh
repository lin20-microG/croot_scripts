#!/bin/bash

# Own values
export CCACHE_DIR=~/out-android/.ccache
export OUT_DIR_COMMON_BASE=~/out-android

# Use pre-defined build script
source z_patches/build_device.sh beyond1lte $1
