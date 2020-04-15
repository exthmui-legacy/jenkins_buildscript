#!/bin/bash
cd ${EXTHM_SOURCE_PATH}
. build/envsetup.sh
lunch exthm_${TARGET_CODE_NAME}-userdebug
