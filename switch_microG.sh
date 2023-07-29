#!/bin/bash

#
# Switch script to switch/checkout to the defined branches
# for each build variant and to apply the respective patches
#
# After initial `repo sync`, the branches are initially
# created and checked out
# ------------------------------------------------------------


switch_branches() {
  TOPDIR=$PWD
  cd $2
  echo "-"
  echo "$PWD"
  if [ "$2" == ".repo/local_manifests" ] ; then
    REMOTE="origin"
  else
    REMOTE="github"
  fi
  if [ -n "$(git branch --list $1)" ]; then
    git checkout $1
    git pull $REMOTE $1 --ff-only
  else
    git fetch $REMOTE $1
    git checkout -b $1 $REMOTE/$1
  fi
  cd $TOPDIR
}

switch_zpatch() {
  TOPDIR=$PWD
  cd z_patches
  echo "-"
  echo "$PWD"
  case "$2" in
    R) ./patches_reverse.sh
       cd $TOPDIR
       switch_branches $1 z_patches
       ;;
    S) ./patches_apply.sh
       ;;
  esac
  cd $TOPDIR
}

#
# Main run
#
case "$1" in
  microG)
    BRANCH1="lin-20.0-microG"
    BRANCH2="lin-20.0-microG"
    PATCHV="S"
    ;;
  default)
    BRANCH1="lineage-20.0"
    BRANCH2="lineage-20.0"
    PATCHV="S"
    ;;
  reference)
    BRANCH1="lineage-20.0"
    BRANCH2="changelog"
    PATCHV="N"
    ;;
  *)
    echo "usage: switch_microg.sh default | microG | reference"
    echo "-"
    echo "  default   - LineageOS 20.0"
    echo "  microG    - hardened microG build (low memory devices)"
    echo "  reference - 100% LineageOS 18.1 (no patches - for 'repo sync')"
    exit
    ;;
esac

switch_zpatch $BRANCH1 R

switch_branches $BRANCH1 bionic
switch_branches $BRANCH1 build/make
switch_branches $BRANCH1 build/soong
switch_branches $BRANCH1 frameworks/base
switch_branches $BRANCH1 frameworks/native
switch_branches $BRANCH1 libcore
switch_branches $BRANCH1 packages/apps/Jelly
switch_branches $BRANCH1 packages/apps/LineageParts
switch_branches $BRANCH1 packages/apps/Settings
switch_branches $BRANCH1 packages/apps/Trebuchet
#switch_branches $BRANCH1 packages/modules/Connectivity
switch_branches $BRANCH1 packages/modules/DnsResolver
#switch_branches $BRANCH1 packages/modules/NetworkStack
switch_branches $BRANCH1 packages/modules/Permission
switch_branches $BRANCH1 packages/modules/Wifi
switch_branches $BRANCH1 packages/providers/MediaProvider
switch_branches $BRANCH1 system/core
switch_branches $BRANCH1 system/sepolicy
switch_branches $BRANCH1 vendor/lineage
#switch_branches $BRANCH1 .repo/local_manifests
#switch_branches $BRANCH2 OTA

switch_zpatch $BRANCH1 $PATCHV
