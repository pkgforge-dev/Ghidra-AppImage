#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# ghidra depends on java-environment, but a JRE is enough to run it
pacman -Syu --noconfirm --assume-installed java-environment=27 jre-openjdk ghidra

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

rm -rf /opt/ghidra/Extensions/Ghidra/Skeleton/src /opt/ghidra/GPL/DMG/src /opt/ghidra/docs /opt/ghidra/GPL/DemanglerGnu/src /opt/ghidra/licenses /opt/ghidra/GPL/licenses

# ghidra's launchers ask for a JDK, but a JRE can run it just fine
sed -i 's/JAVA_TYPE_ARG="-jdk_home"/JAVA_TYPE_ARG="-java_home"/' /opt/ghidra/support/launch.sh
grep -q 'JAVA_TYPE_ARG="-java_home"' /opt/ghidra/support/launch.sh

# quick-sharun would dereference this symlink and copy all of /usr/share/man
rm -rf /usr/lib/jvm/java-*/man

mkdir -p ./AppDir/bin
cp -rv /opt/ghidra/* ./AppDir/bin
