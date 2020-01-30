#!/bin/bash
rm -rf out
mkdir out
cp ${WORK_DIR}/out/target/product/${TARGET_CODE_NAME}/*.zip ./out
