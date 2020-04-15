#!/bin/bash
rm -rf out
mkdir out

cp ${EXTHM_SOURCE_PATH}/out/target/product/${TARGET_CODE_NAME}/exthm-*.zip ./out
#rclone purge isning-od:/rom/${TARGET_CODE_NAME}
#rclone mkdir isning-od:/rom/${TARGET_CODE_NAME}
#rclone copy out/* isning-od:/rom/${TARGET_CODE_NAME}
