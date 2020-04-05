
add_date=${4:-no}
build_type=${3:-alpha}
lto=${2:-no}
make_clean=${1:-clean}

version=$BUILDKERNEL_VERSION
# Kernel
KERNEL_DIR=$PWD
KERNEL="Image.gz-dtb"
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz

JASON_NONTREBLE_IMG=$KERNEL_DIR/out/arch/arm64/boot/dts/qcom/sdm660-mtp-jason.dtb
JASON_TREBLE_IMG=$KERNEL_DIR/out/arch/arm64/boot/dts/qcom/sdm660-mtp-jason-treble.dtb
WHYRED_TREBLE_IMG=$KERNEL_DIR/out/arch/arm64/boot/dts/qcom/sdm636-mtp-whyred.dtb
LAVENDER_TREBLE_IMG=$KERNEL_DIR/out/arch/arm64/boot/dts/qcom/sdm660-mtp-lavender.dtb
WAYNE_TREBLE_IMG=$KERNEL_DIR/out/arch/arm64/boot/dts/qcom/sdm660-mtp-wayne.dtb
JASMINE_TREBLE_IMG=$KERNEL_DIR/out/arch/arm64/boot/dts/qcom/sdm660-mtp-jasmine.dtb

CROSS_COMPILE_PATH=${HOME}/androidProjects/prebuilts/arm64-gcc/bin/aarch64-elf-
CROSS_COMPILE32_PATH=${HOME}/androidProjects/prebuilts/arm-eabi-gcc/bin/arm-eabi-
export KERNEL_USE_CCACHE=1

# Build Start [needed for calculating time]
BUILD_START=$(date +"%s")

# AnyKernel2 Dir
ANYKERNEL_DIR=${HOME}/androidProjects/AnyKernel3

# Export Zip Here
EXPORT_DIR=${HOME}/androidProjects/flashables

ZIP_NAME="forest"
ZIP_NAME+="_kernel-"
ZIP_NAME+="${BUILDKERNEL_DEVICE}-"
if [[ $build_type == "stable" ]]; then
  ZIP_NAME+="stable-"
  ZIP_NAME+="v$version"
fi

if [[ $build_type == "alpha" ]]; then
  ZIP_NAME+="alpha-"
  ZIP_NAME+="v$version"
fi

if [[ $build_type == "beta" ]]; then
  ZIP_NAME+="beta-"
  ZIP_NAME+="v$version"
fi

if [[ $build_type == "rc" ]]; then
  ZIP_NAME+="stable-rc-"
  ZIP_NAME+="v$version"
fi

if [[ $add_date == "yes" ]]; then
  DASH_DATE=`echo $(date +'%d/%m/%Y/%H%M') | sed 's/\//-/g'`
  ZIP_NAME+="-$DASH_DATE"
fi

# Set User and Host
export KBUILD_BUILD_USER="uvera"
export KBUILD_BUILD_HOST="${BUILDKERNEL_DEVICE}"

echo "-----------------------------------------------"
echo "  Initializing build to compile Ver: $ZIP_NAME "
echo "-----------------------------------------------"

echo -e "***********************************************"
echo     "         Creating Output Directory: out       "
echo -e "***********************************************"

# Create Out
mkdir -p out

echo -e "***********************************************"
echo    "         Initialising ${BUILDKERNEL_DEVICE}_defconfig    "
echo -e "***********************************************"

if [[ $make_clean == "clean" ]]; then
echo -e "Cleaning up..."
	make mrproper 2>>/dev/null
	make clean 2>>/dev/null
fi

rm ${ANYKERNEL_DIR}/treble/*
rm ${ANYKERNEL_DIR}/nontreble/*

# Init Defconfig
make O=out ARCH=arm64 ${BUILDKERNEL_DEVICE}_defconfig

if [[ $lto == "lto" ]]; then
echo -e "Bulding with LTO..."
	sed 's/# CONFIG_LTO is not set/CONFIG_LTO=y/g' ${KERNEL_DIR}/out/.config > ${KERNEL_DIR}/out/.config.new
	mv ${KERNEL_DIR}/out/.config.new ${KERNEL_DIR}/out/.config
	sed 's/# CONFIG_LD_DEAD_CODE_DATA_ELIMINATION is not set/CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y/g' ${KERNEL_DIR}/out/.config > ${KERNEL_DIR}/out/.config.new
	mv ${KERNEL_DIR}/out/.config.new ${KERNEL_DIR}/out/.config
fi

echo -e "***********************************************"
echo    "          Cooking Kernel                       "
echo -e "***********************************************"

# make
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
					  CROSS_COMPILE_ARM32=${CROSS_COMPILE32_PATH} \
                      CROSS_COMPILE=${CROSS_COMPILE_PATH}

echo -e "***********************************************"
echo    "            Making Flashable Zip               "
echo -e "***********************************************"
   # AnyKernel2 Magic Begins!
   # Make the zip file
   echo "MAKING FLASHABLE ZIP"

   # Move the zImage to AnyKernel2 dir
   cp -vr ${KERN_IMG} ${ANYKERNEL_DIR}/kernel/Image.gz
   cp -vr ${LAVENDER_TREBLE_IMG} ${ANYKERNEL_DIR}/treble/sdm660-mtp-lavender.dtb
   cp -vr ${WAYNE_TREBLE_IMG} ${ANYKERNEL_DIR}/treble/sdm660-mtp-wayne.dtb
   cp -vr ${JASMINE_TREBLE_IMG} ${ANYKERNEL_DIR}/treble/sdm660-mtp-jasmine.dtb
   cp -vr ${WHYRED_TREBLE_IMG} ${ANYKERNEL_DIR}/treble/sdm636-mtp-whyred.dtb
   cp -vr ${JASON_TREBLE_IMG} ${ANYKERNEL_DIR}/treble/sdm660-mtp-jason.dtb
   cp -vr ${JASON_NONTREBLE_IMG} ${ANYKERNEL_DIR}/nontreble/sdm660-mtp-jason.dtb
   cd ${ANYKERNEL_DIR}
   zip -r9 ${ZIP_NAME}.zip * -x README ${ZIP_NAME}.zip

# Export Zip
NOW=$(date +"%m-%d")
ZIP_LOCATION=${ANYKERNEL_DIR}/${ZIP_NAME}.zip
ZIP_EXPORT=${EXPORT_DIR}/${NOW}
ZIP_EXPORT_LOCATION=${EXPORT_DIR}/${NOW}/${ZIP_NAME}.zip

rm -rf ${ZIP_EXPORT}
mkdir ${ZIP_EXPORT}
mv ${ZIP_LOCATION} ${ZIP_EXPORT}
cd ${KERNEL_DIR}

echo ""

echo "------------------------------"
echo $ZIP_EXPORT_LOCATION
echo -e "\n------------------------------"

echo ""

# End the script
echo "${BUILD_RESULT_STRING}!"

# End the Build and Print the Compilation Time
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
