#!/bin/bash
rm -rf out
mkdir out

cp ${WORK_DIR}/out/target/product/${TARGET_CODE_NAME}/lineage-*.zip ./out
rclone purge isning-od:/rom/${TARGET_CODE_NAME}
rclone mkdir isning-od:/rom/${TARGET_CODE_NAME}
rclone copy out/* isning-od:/rom/${TARGET_CODE_NAME}
