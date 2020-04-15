#!/bin/bash
cd ${EXTHM_SOURCE_PATH}
. build/envsetup.sh
rm out/target/product/${TARGET_CODE_NAME}/exthm-*.zip
#rm out/target/product/${TARGET_CODE_NAME}/*.img
lunch exthm_${TARGET_CODE_NAME}-userdebug
mka bacon -j${BUILD_THREADS}
