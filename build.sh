#!/bin/bash

set -o errexit -o pipefail

[[ $# -eq 0 ]] || exit 1

ROOT_DIR=$(realpath ../../..)

PATH="$ROOT_DIR/prebuilts/build-tools/linux-x86/bin:$PATH"
PATH="$ROOT_DIR/prebuilts/build-tools/path/linux-x86:$PATH"
PATH="$ROOT_DIR/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH"
PATH="$ROOT_DIR/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin:$PATH"
PATH="$ROOT_DIR/prebuilts/clang/host/linux-x86/clang-r383902/bin:$PATH"
PATH="$ROOT_DIR/prebuilts/misc/linux-x86/lz4:$PATH"
PATH="$ROOT_DIR/prebuilts/misc/linux-x86/dtc:$PATH"
PATH="$ROOT_DIR/prebuilts/misc/linux-x86/libufdt:$PATH"
export LD_LIBRARY_PATH="$ROOT_DIR/prebuilts/clang/host/linux-x86/clang-r383902/lib64:$LD_LIBRARY_PATH"
export DTC_EXT="$ROOT_DIR/prebuilts/misc/linux-x86/dtc/dtc"
export DTC_OVERLAY_TEST_EXT="$ROOT_DIR/prebuilts/misc/linux-x86/libufdt/ufdt_apply_overlay"

export KBUILD_BUILD_VERSION=1
export KBUILD_BUILD_USER=grapheneos
export KBUILD_BUILD_HOST=grapheneos
export KBUILD_BUILD_TIMESTAMP="$(date -ud "@$(git show -s --format=%ct)")"

chrt -bp 0 $$

make \
    O=out \
    ARCH=arm64 \
    CC=clang \
    LD=ld.lld \
    AR=llvm-ar \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    READELF=llvm-readelf \
    OBJSIZE=llvm-size \
    STRIP=llvm-strip \
    HOSTCC=clang \
    HOSTCXX=clang++ \
    HOSTLD=ld.lld \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi- \
    floral_defconfig

make -j$(nproc) \
    O=out \
    ARCH=arm64 \
    CC=clang \
    LD=ld.lld \
    AR=llvm-ar \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    READELF=llvm-readelf \
    OBJSIZE=llvm-size \
    STRIP=llvm-strip \
    HOSTCC=clang \
    HOSTCXX=clang++ \
    HOSTLD=ld.lld \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi-

cp out/arch/arm64/boot/{dtbo.img,Image.lz4} "$ROOT_DIR/device/google/coral-kernel"
cp out/arch/arm64/boot/dts/google/qcom-base/sm8150.dtb "$ROOT_DIR/device/google/coral-kernel"
cp out/arch/arm64/boot/dts/google/qcom-base/sm8150-v2.dtb "$ROOT_DIR/device/google/coral-kernel"
