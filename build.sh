#!/bin/bash
#
# Copyright © 2018-2019, "DarkAngelGR" <asavvo01@gmail.com>
# Thanks to Vipul Jha for zip creator
# Android Kernel Compilation Script
#

tput reset
echo -e "==============================================="
echo    "         Compiling Olympian Kernel             "
echo -e "==============================================="

LC_ALL=C date +%Y-%m-%d
date=`date +"%Y%m%d-%H%M"`
BUILD_START=$(date +"%s")
KERNEL_DIR=$PWD
REPACK_DIR=$KERNEL_DIR/zip
OUT=$KERNEL_DIR/out
VERSION="zeus"
export ARCH=arm64 && export SUBARCH=arm64
export CROSS_COMPILE="/home/DarkAngelGR/Toolchain/bin/aarch64-linux-android-4.9/bin/aarch64-linux-android-"

rm -rf out
mkdir -p out
make mrproper
make O=out clean
make O=out mrproper
make O=out olympian_markw_defconfig
make O=out -j$(nproc --all)

cd $REPACK_DIR
cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR/
FINAL_ZIP="OlympianKernel-${VERSION}.zip"
zip -r9 "${FINAL_ZIP}" *
cp *.zip $OUT
rm *.zip
cd $KERNEL_DIR
rm zip/Image.gz-dtb

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
