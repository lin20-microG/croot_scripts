#!/bin/bash

rm nohup.out
# Out directory on SSD
export OUT_DIR_COMMON_BASE=~/out-android
. build/make/envsetup.sh
m -j  clean

