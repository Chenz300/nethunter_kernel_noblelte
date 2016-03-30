#!/bin/bash
# NetHunter kernel for Samsung Galaxy Note 5 / S6 / S6 Edge / S6 Edge+ build script by jcadduono
# This build script builds all variants in ./VARIANTS
#
###################### CONFIG ######################

# root directory of NetHunter noblelte git repo (default is this script's location)
RDIR=$(pwd)

# output directory of Image and dtb.img
OUT_DIR=$HOME/build/kali-nethunter/nethunter-installer/kernels/marshmallow

############## SCARY NO-TOUCHY STUFF ###############

ARCH=arm64
KDIR=$RDIR/build/arch/$ARCH/boot

MOVE_IMAGES()
{
	echo "Moving kernel Image and dtb.img to $VARIANT_DIR/..."
	mkdir -p "$VARIANT_DIR"
	rm -f "$VARIANT_DIR/Image" "$VARIANT_DIR/dtb.img"
	mv "$KDIR/Image" "$KDIR/dtb.img" "$VARIANT_DIR/"
}

mkdir -p $OUT_DIR

[ "$DEVICE" ] || DEVICE=noblelte
[ "$1" ] && {
	VARIANTS=$*
} || {
	VARIANTS=$(cat "$RDIR/VARIANTS")
}

export TARGET=nethunter
export DEVICE

for VARIANT in $VARIANTS
do
	[ "$VARIANT" == "eur" ] && {
		VARIANT_DIR=$OUT_DIR/$DEVICE
	} || {
		VARIANT_DIR=$OUT_DIR/$DEVICE$VARIANT
	}
	"$RDIR/build.sh" "$VARIANT" && MOVE_IMAGES || {
		echo "Failed to build $DEVICE-$VARIANT! Aborting..."
		exit 1
	}
done

echo "Finished building NetHunter kernels!"
