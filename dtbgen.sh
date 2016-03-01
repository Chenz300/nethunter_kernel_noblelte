#!/bin/bash
# simple bash script for generating dtb image

# directory containing cross-compile arm64 toolchain
TOOLCHAIN=$HOME/build/toolchain/android-arm64-4.9

# device dependant variables
PAGE_SIZE=2048
DTB_PADDING=0

export ARCH=arm64
export CROSS_COMPILE=$TOOLCHAIN/bin/aarch64-linux-android-

RDIR=$(pwd)
OUTDIR=$RDIR/build/arch/$ARCH/boot
DTSDIR=$RDIR/arch/$ARCH/boot/dts
DTBDIR=$OUTDIR/dts
DTCTOOL=$RDIR/build/scripts/dtc/dtc
INCDIR=$RDIR/include

[ -f "$DTCTOOL" ] || {
	echo "You need to run ./build.sh first!"
	exit 1
}

[ "$DEVICE" ] || DEVICE=noblelte
[ "$1" ] && {
	VARIANT=$1
} || {
	VARIANT=eur
}

case $DEVICE in
noblelte)
	case $VARIANT in
	eur|duos)
		DTSFILES="exynos7420-noblelte_eur_open_00 exynos7420-noblelte_eur_open_01
				exynos7420-noblelte_eur_open_02 exynos7420-noblelte_eur_open_03
				exynos7420-noblelte_eur_open_04 exynos7420-noblelte_eur_open_05
				exynos7420-noblelte_eur_open_06
				exynos7420-noblelte_eur_open_08 exynos7420-noblelte_eur_open_09"
		;;
	zt|chn)
		DTSFILES="exynos7420-noblelte_chn_01 exynos7420-noblelte_chn_02
				exynos7420-noblelte_chn_03 exynos7420-noblelte_chn_04
				exynos7420-noblelte_chn_06
				exynos7420-noblelte_chn_07 exynos7420-noblelte_chn_08
				exynos7420-noblelte_chn_09"
		;;
	chnmdm|mdm)
		DTSFILES="exynos7420-noblelte_chn_mdm_00 exynos7420-noblelte_chn_mdm_01
				exynos7420-noblelte_chn_mdm_02 exynos7420-noblelte_chn_mdm_03
				exynos7420-noblelte_chn_mdm_04
				exynos7420-noblelte_chn_mdm_06 exynos7420-noblelte_chn_mdm_07
				exynos7420-noblelte_chn_mdm_08 exynos7420-noblelte_chn_mdm_09"
		;;
	jpn)
		DTSFILES="exynos7420-noblelte_jpn_00 exynos7420-noblelte_jpn_01
				exynos7420-noblelte_jpn_02 exynos7420-noblelte_jpn_03
				exynos7420-noblelte_jpn_04 exynos7420-noblelte_jpn_05
				exynos7420-noblelte_jpn_06 exynos7420-noblelte_jpn_07
				exynos7420-noblelte_jpn_08 exynos7420-noblelte_jpn_09"
		;;
	kor|ktt|skt|lgt)
		DTSFILES="exynos7420-noblelte_kor_00 exynos7420-noblelte_kor_01
				exynos7420-noblelte_kor_02 exynos7420-noblelte_kor_03
				exynos7420-noblelte_kor_04
				exynos7420-noblelte_kor_06 exynos7420-noblelte_kor_07
				exynos7420-noblelte_kor_08 exynos7420-noblelte_kor_09"
		;;
	usa|tmo|can|att)
		DTSFILES="exynos7420-noblelte_usa_00 exynos7420-noblelte_usa_01
				exynos7420-noblelte_usa_02 exynos7420-noblelte_usa_03
				exynos7420-noblelte_usa_04
				exynos7420-noblelte_usa_06 exynos7420-noblelte_usa_07
				exynos7420-noblelte_usa_08 exynos7420-noblelte_usa_09"
		;;
	cdma|spr|usc|vzw)
		DTSFILES="exynos7420-noblelte_usa_cdma_00 exynos7420-noblelte_usa_cdma_01
				exynos7420-noblelte_usa_cdma_02 exynos7420-noblelte_usa_cdma_03
				exynos7420-noblelte_usa_cdma_04
				exynos7420-noblelte_usa_cdma_06 exynos7420-noblelte_usa_cdma_07
				exynos7420-noblelte_usa_cdma_08 exynos7420-noblelte_usa_cdma_09"
		;;
	sea|xtc)
		DTSFILES="exynos7420-noblelte_sea_xtc_00 exynos7420-noblelte_sea_xtc_01
				exynos7420-noblelte_sea_xtc_02 exynos7420-noblelte_sea_xtc_03
				exynos7420-noblelte_sea_xtc_04 exynos7420-noblelte_sea_xtc_05
				exynos7420-noblelte_sea_xtc_06
				exynos7420-noblelte_sea_xtc_08 exynos7420-noblelte_sea_xtc_09"
		;;
	*)
		echo "Unknown variant for $DEVICE: $VARIANT"
		exit 1
		;;
	esac
	;;
zenlte)
	case $VARIANT in
	eur|duos)
		DTSFILES="exynos7420-zenlte_eur_open_00 exynos7420-zenlte_eur_open_01
				exynos7420-zenlte_eur_open_02 exynos7420-zenlte_eur_open_03
				exynos7420-zenlte_eur_open_04
				exynos7420-zenlte_eur_open_07 exynos7420-zenlte_eur_open_08
				exynos7420-zenlte_eur_open_09"
		;;
	zt|chn)
		DTSFILES="exynos7420-zenlte_chn_03 exynos7420-zenlte_chn_04
				exynos7420-zenlte_chn_08 exynos7420-zenlte_chn_09"
		;;
	chnmdm|mdm)
		DTSFILES="exynos7420-zenlte_chn_mdm_00 exynos7420-zenlte_chn_mdm_01
				exynos7420-zenlte_chn_mdm_02 exynos7420-zenlte_chn_mdm_03
				exynos7420-zenlte_chn_mdm_04
				exynos7420-zenlte_chn_mdm_08 exynos7420-zenlte_chn_mdm_09"
		;;
	jpn)
		DTSFILES="exynos7420-zenlte_jpn_00 exynos7420-zenlte_jpn_01
				exynos7420-zenlte_jpn_02 exynos7420-zenlte_jpn_03"
		;;
	kor|ktt|skt|lgt)
		DTSFILES="exynos7420-zenlte_kor_00 exynos7420-zenlte_kor_01
				exynos7420-zenlte_kor_02 exynos7420-zenlte_kor_03
				exynos7420-zenlte_kor_04
				exynos7420-zenlte_kor_08 exynos7420-zenlte_kor_09"
		;;
	usa|tmo|can|att)
		DTSFILES="exynos7420-zenlte_usa_00 exynos7420-zenlte_usa_01
				exynos7420-zenlte_usa_02 exynos7420-zenlte_usa_03
				exynos7420-zenlte_usa_04
				exynos7420-zenlte_usa_08 exynos7420-zenlte_usa_09"
		;;
	cdma|spr|usc|vzw)
		DTSFILES="exynos7420-zenlte_usa_cdma_00 exynos7420-zenlte_usa_cdma_01
				exynos7420-zenlte_usa_cdma_02 exynos7420-zenlte_usa_cdma_03
				exynos7420-zenlte_usa_cdma_04
				exynos7420-zenlte_usa_cdma_08 exynos7420-zenlte_usa_cdma_09"
		;;
	*)
		echo "Unknown variant for $DEVICE: $VARIANT"
		exit 1
		;;
	esac
	;;
zerolte)
	case $VARIANT in
	eur|duos)
		DTSFILES="exynos7420-zerolte_eur_open_00 exynos7420-zerolte_eur_open_01
				exynos7420-zerolte_eur_open_02 exynos7420-zerolte_eur_open_03
				exynos7420-zerolte_eur_open_04 exynos7420-zerolte_eur_open_05
				exynos7420-zerolte_eur_open_06 exynos7420-zerolte_eur_open_07
				exynos7420-zerolte_eur_open_08"
		;;
	zt|chn)
		DTSFILES="exynos7420-zerolte_chn_00 exynos7420-zerolte_chn_01
				exynos7420-zerolte_chn_02"
		;;
	jpn)
		DTSFILES="exynos7420-zerolte_jpn_00 exynos7420-zerolte_jpn_01
				exynos7420-zerolte_jpn_02 exynos7420-zerolte_jpn_03
				exynos7420-zerolte_jpn_04 exynos7420-zerolte_jpn_05
				exynos7420-zerolte_jpn_06"
		;;
	kor|ktt|skt|lgt)
		DTSFILES="exynos7420-zerolte_kor_00 exynos7420-zerolte_kor_01
				exynos7420-zerolte_kor_02 exynos7420-zerolte_kor_03
				exynos7420-zerolte_kor_04 exynos7420-zerolte_kor_05
				exynos7420-zerolte_kor_06 exynos7420-zerolte_kor_07"
		;;
	usa|tmo|can|att)
		DTSFILES="exynos7420-zerolte_usa_00 exynos7420-zerolte_usa_01
				exynos7420-zerolte_usa_02 exynos7420-zerolte_usa_03
				exynos7420-zerolte_usa_04 exynos7420-zerolte_usa_05
				exynos7420-zerolte_usa_06 exynos7420-zerolte_usa_07"
		;;
	cdma|spr|usc|vzw)
		DTSFILES="exynos7420-zerolte_usa_cdma_00 exynos7420-zerolte_usa_cdma_01
				exynos7420-zerolte_usa_cdma_02 exynos7420-zerolte_usa_cdma_03
				exynos7420-zerolte_usa_cdma_04 exynos7420-zerolte_usa_cdma_05"
		;;
	*)
		echo "Unknown variant for $DEVICE: $VARIANT"
		exit 1
		;;
	esac
	;;
zeroflte)
	case $VARIANT in
	eur|duos)
		DTSFILES="exynos7420-zeroflte_eur_open_00 exynos7420-zeroflte_eur_open_01
				exynos7420-zeroflte_eur_open_02 exynos7420-zeroflte_eur_open_03
				exynos7420-zeroflte_eur_open_04 exynos7420-zeroflte_eur_open_05
				exynos7420-zeroflte_eur_open_06 exynos7420-zeroflte_eur_open_07"
		;;
	zt|chn)
		DTSFILES="exynos7420-zeroflte_chn_00 exynos7420-zeroflte_chn_01
				exynos7420-zeroflte_chn_02 exynos7420-zeroflte_chn_03
				exynos7420-zeroflte_chn_04"
		;;
	jpn)
		DTSFILES="exynos7420-zeroflte_jpn_00 exynos7420-zeroflte_jpn_01
				exynos7420-zeroflte_jpn_02 exynos7420-zeroflte_jpn_03
				exynos7420-zeroflte_jpn_04"
		;;
	kor|ktt|skt|lgt)
		DTSFILES="exynos7420-zeroflte_kor_00 exynos7420-zeroflte_kor_01
				exynos7420-zeroflte_kor_02 exynos7420-zeroflte_kor_03
				exynos7420-zeroflte_kor_04 exynos7420-zeroflte_kor_05
				exynos7420-zeroflte_kor_06 exynos7420-zeroflte_kor_07"
		;;
	usa|tmo|can|att)
		DTSFILES="exynos7420-zeroflte_usa_00 exynos7420-zeroflte_usa_01
				exynos7420-zeroflte_usa_02 exynos7420-zeroflte_usa_03
				exynos7420-zeroflte_usa_04 exynos7420-zeroflte_usa_05"
		;;
	cdma|spr|usc|vzw)
		DTSFILES="exynos7420-zeroflte_usa_cdma_00 exynos7420-zeroflte_usa_cdma_01
				exynos7420-zeroflte_usa_cdma_02 exynos7420-zeroflte_usa_cdma_03"
		;;
	*)
		echo "Unknown variant for $DEVICE: $VARIANT"
		exit 1
		;;
	esac
	;;
*)
	echo "Unknown device: $DEVICE"
	exit 1
	;;
esac

mkdir -p $OUTDIR $DTBDIR

cd $DTBDIR || {
	echo "Unable to cd to $DTBDIR!"
	exit 1
}

rm -f ./*

echo "Processing dts files..."

for dts in $DTSFILES; do
	echo "=> Processing: ${dts}.dts"
	${CROSS_COMPILE}cpp -nostdinc -undef -x assembler-with-cpp -I "$INCDIR" "$DTSDIR/${dts}.dts" > "${dts}.dts"
	echo "=> Generating: ${dts}.dtb"
	$DTCTOOL -p $DTB_PADDING -i "$DTSDIR" -O dtb -o "${dts}.dtb" "${dts}.dts"
done

echo "Generating dtb.img..."
$RDIR/scripts/dtbTool/dtbTool -o "$OUTDIR/dtb.img" -d "$DTBDIR/" -s $PAGE_SIZE

echo "Done."
