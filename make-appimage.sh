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

# passing the AppDir directories makes quick-sharun flatten the scripts found
# in them, only the native binaries need to be deployed
native_bins=$(find ./AppDir/bin -type f -exec sh -c '
	for f; do
		if head -c 4 "$f" 2>/dev/null | grep -qa ELF; then
			printf "%s\n" "$f"
		fi
	done
' sh {} +)

# Deploy dependencies
quick-sharun /usr/bin/ghid* /usr/bin/bash $native_bins /usr/lib/jvm/java*

# the launchers copied from /usr/bin need to resolve the support directory
ln -sfn support/analyzeHeadless ./AppDir/bin/ghidra-analyzeHeadless
ln -sfn support/pyghidraRun ./AppDir/bin/pyghidra

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
