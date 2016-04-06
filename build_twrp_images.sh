#!/bin/bash
# TWRP kernel for Samsung Galaxy Note 5 / S6 / S6 Edge / S6 Edge+ build script by jcadduono
# This build script builds all variants in ./VARIANTS
#
###################### CONFIG ######################

# root directory of TWRP noblelte git repo (default is this script's location)
RDIR=$(pwd)

# output directory of Image and dtb.img
OUT_DIR=/home/jc/build/twrp/device/samsung

############## SCARY NO-TOUCHY STUFF ###############

ARCH=arm64
KDIR=$RDIR/build/arch/$ARCH/boot

BUILD_DEVICE=$DEVICE

MOVE_IMAGES()
{
	echo "Moving kernel Image and dtb.img to $1/..."
	mkdir -p "$1"
	rm -f "$1/Image" "$1/dtb.img"
	mv "$KDIR/Image" "$KDIR/dtb.img" "$1/"
}

BUILD_VARIANTS()
{
	for VARIANT in $2
	do
		[ "$VARIANT" == "eur" ] && {
			VARIANT_DIR=$OUT_DIR/$1
		} || {
			VARIANT_DIR=$OUT_DIR/$1$VARIANT
		}
		DEVICE="$1" "$RDIR/build.sh" "$VARIANT" && MOVE_IMAGES "$VARIANT_DIR" || {
			echo "Failed to build $1-$VARIANT! Aborting..."
			exit 1
		}
	done
}

export TARGET=twrp

while read line; do
	CURRENT_DEVICE=$(echo "$line" | awk -F'=' '{print $1}')
	if [ "$BUILD_DEVICE" -a ! "$BUILD_DEVICE" = "$CURRENT_DEVICE" ]; then
		continue
	fi
	if [ "$1" ]; then
		VARIANTS=$1
	else
		VARIANTS=$(echo "$line" | awk -F'=' '{print $2}')
	fi
	BUILD_VARIANTS "$CURRENT_DEVICE" "$VARIANTS"
done < "$RDIR/VARIANTS"

echo "Finished building TWRP kernels!"
