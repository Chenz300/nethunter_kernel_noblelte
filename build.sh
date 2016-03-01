#!/bin/bash
# Samsung kernel for Samsung Galaxy Note 5 / S6 / S6 Edge / S6 Edge+ build script by jcadduono

################### BEFORE STARTING ################
#
# download a working toolchain and extract it somewhere and configure this
# file to point to the toolchain's root directory.
#
# once you've set up the config section how you like it, you can simply run
# ./build.sh [VARIANT]
#
##################### DEVICES ######################
#
# noblelte = Galaxy Note 5
#            SM-N920
#
# zenlte   = Galaxy S6 Edge+
#            SM-G928
#
# zerolte  = Galaxy S6 Edge
#            SM-G925
#
# zeroflte = Galaxy S6
#            SM-G920
#
##################### VARIANTS #####################
#
# can = W8 (Canada)
# eur = C/CD/F/FD (Europe)
# zt  = 0/8 (China Duos)
# spr = P (Sprint)
# tmo = T (T-Mobile)
# usc = R4 (US Cellular)
# ktt = K (Korea - KT Corporation)
# lgt = L (Korea - LG Telecom)
# skt = S (Korea - SK Telecom)
# kor = K/L/S (Korea - Unified)
#
###################### CONFIG ######################

# root directory of NetHunter noblelte git repo (default is this script's location)
RDIR=$(pwd)

[ $VER ] || \
# version number
VER=$(cat $RDIR/VERSION)

# directory containing cross-compile arm64 toolchain
TOOLCHAIN=$HOME/build/toolchain/android-arm64-4.9

# amount of cpu threads to use in kernel make process
THREADS=5

############## SCARY NO-TOUCHY STUFF ###############

export ARCH=arm64
export CROSS_COMPILE=$TOOLCHAIN/bin/aarch64-linux-android-

[ "$DEVICE" ] || DEVICE=noblelte
[ "$TARGET" ] || TARGET=samsung
[ "$1" ] && {
	VARIANT=$1
} || {
	VARIANT=eur
}
DEFCONFIG=${TARGET}_defconfig
DEVICE_DEFCONFIG=${DEVICE}/device_defconfig
VARIANT_DEFCONFIG=${DEVICE}/variant_${VARIANT}_defconfig

[ -f "$RDIR/arch/$ARCH/configs/$DEFCONFIG" ] || {
	echo "Config $DEFCONFIG not found in $ARCH configs!"
	exit 1
}

[ -f "$RDIR/arch/$ARCH/configs/$DEVICE_DEFCONFIG" ] || {
	echo "Device $DEVICE not found in $ARCH configs!"
	exit 1
}

[ -f "$RDIR/arch/$ARCH/configs/$VARIANT_DEFCONFIG" ] || {
	echo "Variant $VARIANT not found for $DEVICE in $ARCH configs!"
	exit 1
}

export LOCALVERSION="$TARGET-$DEVICE-$VARIANT-$VER"

KDIR=$RDIR/arch/$ARCH/boot

CLEAN_BUILD()
{
	echo "Cleaning build..."
	cd $RDIR
	rm -rf build
}

BUILD_KERNEL()
{
	echo "Creating kernel config..."
	cd $RDIR
	mkdir -p build
	make -C $RDIR O=build $DEFCONFIG \
		DEVICE_DEFCONFIG=$DEVICE_DEFCONFIG \
		VARIANT_DEFCONFIG=$VARIANT_DEFCONFIG
	echo "Starting build for $LOCALVERSION..."
	make -C $RDIR O=build -j"$THREADS"
}

BUILD_DTB()
{
	echo "Generating dtb.img..."
	cd $RDIR
	DEVICE=$DEVICE ./dtbgen.sh $VARIANT
}

CLEAN_BUILD && BUILD_KERNEL && BUILD_DTB && echo "Finished building $LOCALVERSION!"
