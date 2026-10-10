#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q ghidra | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/ghidra.png
export DESKTOP=/usr/share/applications/ghidra.desktop

# Deploy dependencies
quick-sharun /usr/bin/ghid* ./AppDir/bin/* /usr/lib/jvm/java*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
