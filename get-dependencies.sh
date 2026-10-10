#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm ghidra

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

rm -rf /opt/ghidra/Extensions/Ghidra/Skeleton/src /opt/ghidra/GPL/DMG/src /opt/ghidra/docs /opt/ghidra/GPL/DemanglerGnu/src /opt/ghidra/licenses /opt/ghidra/GPL/licenses
mkdir -p ./AppDir/bin
cp -rv /opt/ghidra/* ./AppDir/bin
