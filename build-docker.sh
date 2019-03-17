#!/bin/bash
mkdir /output

KODITAG=18.1-Leia
# Install Ubuntu Packages
apt-get update
apt-get install zip git wget autoconf build-essential curl default-jdk gawk git gperf lib32stdc++6 lib32z1 lib32z1-dev libcurl4-openssl-dev unzip zlib1g-dev python autoconf bison build-essential curl default-jdk gawk git gperf libcurl4-openssl-dev zlib1g-dev -y

# ANDROID PreRequisites

# Download tools
cd $HOME
wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
wget https://dl.google.com/android/repository/android-ndk-r18-linux-x86_64.zip
# Extract tools
mkdir -p $HOME/android-tools/android-sdk-linux
unzip $HOME/sdk-tools-linux-4333796.zip -d $HOME/android-tools/android-sdk-linux
unzip $HOME/android-ndk-r18-linux-x86_64.zip -d $HOME/android-tools
# Clean-up ZIPs
rm $HOME/sdk-tools-linux-4333796.zip
rm $HOME/android-ndk-r18-linux-x86_64.zip

# Configure SDK
cd $HOME/android-tools/android-sdk-linux/tools/bin
yes | ./sdkmanager --licenses
./sdkmanager platform-tools
./sdkmanager "platforms;android-26"
./sdkmanager "build-tools;25.0.3"
# Configure NDK
cd $HOME/android-tools/android-ndk-r18/build/tools
./make-standalone-toolchain.sh --install-dir=$HOME/android-tools/aarch64-linux-android-vanilla/android-21 --platform=android-21 --toolchain=aarch64-linux-android
./make-standalone-toolchain.sh --install-dir=$HOME/android-tools/arm-linux-androideabi-vanilla/android-21 --platform=android-21 --toolchain=arm-linux-androideabi
./make-standalone-toolchain.sh --install-dir=$HOME/android-tools/x86-linux-android-vanilla/android-21 --platform=android-21 --toolchain=x86-linux-android

# RASPI Prerequisites
cd $HOME
git clone https://github.com/raspberrypi/tools --depth=1
git clone https://github.com/raspberrypi/firmware --depth=1

# Build ENVS

# Prepare Android ARM64
cd $HOME
git clone https://github.com/xbmc/xbmc kodi-android-arm64
cd $HOME/kodi-android-arm64
git checkout $KODITAG
# Build tools
cd tools/depends
./bootstrap
./configure --with-tarballs=$HOME/android-tools/xbmc-tarballs --host=aarch64-linux-android --with-sdk-path=$HOME/android-tools/android-sdk-linux --with-ndk-path=$HOME/android-tools/android-ndk-r18 --with-toolchain=$HOME/android-tools/aarch64-linux-android-vanilla/android-21 --prefix=$HOME/android-tools/xbmc-depends
make -j$(getconf _NPROCESSORS_ONLN)

# Prepare Android ARM
cd $HOME
git clone https://github.com/xbmc/xbmc kodi-android-arm
cd $HOME/kodi-android-arm
git checkout $KODITAG
# Build tools
cd tools/depends
./bootstrap
./configure --with-tarballs=$HOME/android-tools/xbmc-tarballs --host=arm-linux-androideabi --with-sdk-path=$HOME/android-tools/android-sdk-linux --with-ndk-path=$HOME/android-tools/android-ndk-r18 --with-toolchain=$HOME/android-tools/arm-linux-androideabi-vanilla/android-21 --prefix=$HOME/android-tools/xbmc-depends
make -j$(getconf _NPROCESSORS_ONLN)

# Raspi 2
cd $HOME
mkdir $HOME/kodi-rpi2
git clone https://github.com/xbmc/xbmc kodi-pi2
cd $HOME/kodi-pi2
git checkout $KODITAG
cd $HOME/kodi-pi2/tools/depends
./bootstrap
./configure --host=arm-linux-gnueabihf --prefix=$HOME/kodi-rpi2 --with-toolchain=$HOME/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf --with-firmware=$HOME/firmware --with-platform=raspberry-pi2 --disable-debug
make -j$(getconf _NPROCESSORS_ONLN)