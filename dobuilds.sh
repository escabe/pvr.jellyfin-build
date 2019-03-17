#!/bin/bash

# Get addon repro
cd $HOME
git clone https://github.com/escabe/repo-binary-addons.git

export ADDONS_DEFINITION_DIR=$HOME/repo-binary-addons

# Build Android ARM64
cd $HOME/kodi-android-arm64
make -j$(getconf _NPROCESSORS_ONLN) -C tools/depends/target/binary-addons ADDONS="pvr.jellyfin" clean
make -j$(getconf _NPROCESSORS_ONLN) -C tools/depends/target/binary-addons ADDONS="pvr.jellyfin"
cd $HOME/android-tools/xbmc-depends/aarch64-linux-android-21-debug/share/kodi/addons/pvr.jellyfin
cp $HOME/android-tools/xbmc-depends/aarch64-linux-android-21-debug/lib/kodi/addons/pvr.jellyfin/libpvr.jellyfin.so .
cd ..
zip -r /output/pvr.jellyfin-arm64.zip pvr.jellyfin

# Build Android ARM
cd $HOME/kodi-android-arm
make -j$(getconf _NPROCESSORS_ONLN) -C tools/depends/target/binary-addons ADDONS="pvr.jellyfin" clean
make -j$(getconf _NPROCESSORS_ONLN) -C tools/depends/target/binary-addons ADDONS="pvr.jellyfin"
cd $HOME/android-tools/xbmc-depends/arm-linux-androideabi-21-debug/share/kodi/addons/pvr.jellyfin
cp $HOME/android-tools/xbmc-depends/arm-linux-androideabi-21-debug/lib/kodi/addons/pvr.jellyfin/libpvr.jellyfin.so .
cd ..
zip -r /output/pvr.jellyfin-arm.zip pvr.jellyfin

# Build Raspi2
cd $HOME/kodi-pi2
make -j$(getconf _NPROCESSORS_ONLN) -C tools/depends/target/binary-addons ADDONS="pvr.jellyfin" clean
make -j$(getconf _NPROCESSORS_ONLN) -C tools/depends/target/binary-addons ADDONS="pvr.jellyfin"
cd $HOME/kodi-rpi2/raspberry-pi2-release/share/kodi/addons/pvr.jellyfin
cp $HOME/kodi-rpi2/raspberry-pi2-release/lib/kodi/addons/pvr.jellyfin/* .
cd ..
zip -r /output/pvr.jellyfin-rpi2.zip pvr.jellyfin
