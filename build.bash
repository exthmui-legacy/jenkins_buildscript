#!/bin/bash
cd ${WORK_DIR}
. build/envsetup.sh
rm out/target/product/${TARGET_CODE_NAME}/*.zip
rm out/target/product/${TARGET_CODE_NAME}/*.img
lunch exthm_${TARGET_CODE_NAME}-userdebug
mka bacon -j40
