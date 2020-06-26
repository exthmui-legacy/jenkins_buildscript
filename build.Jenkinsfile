def bash(cmd, returnStdout) {
    return sh (script: '#!/bin/bash -e\n'+ cmd, returnStdout: returnStdout)
}

pipeline {
    agent {
        label "$AGENT_LABEL"
    }
/*
    paramenters {
        choice(name:'EXTHM_COMPILERTYPE',choices:'OFFICIAL\nUNOFFICIAL',description:'Type of compiler')
        choice(name:'EXTHM_BUILDTYPE',choices:'SNAPSHOT\nALPHA\nBETA\nRELEASE',description:'Type of this build')
        string(name:'BUILD_THREADS',description:'The number of threads',defaultValue:'16')
        choice(name:'TARGET_VARIANT',choices:'userdebug\neng\nuser',description:'Type of compiler')
    }
*/
    environment {
        TARGET_MANUFACTOR = bash ('echo -n $JOB_NAME | sed -r "s/^exTHmUI_(.[a-z0-9]+)-.[a-z0-9]+$/\\1/"', true)
        TARGET_CODE_NAME = bash ('echo -n $JOB_NAME | sed -r "s/^exTHmUI_.[a-z0-9]+-(.[a-z0-9]+)$/\\1/"', true)
        EXTHM_SOURCE_PATH = "${EXTHM_SOURCE_BASEPATH}/exthm-${TARGET_VERSION}"
        EXTHM_TREES_PATH = "${EXTHM_TREES_BASEPATH}/exthm-${TARGET_VERSION}"
        DEPENDENCIES_FILE_NAME = "exthm.dependencies"
    }
    stages {
        stage('Link trees to source') {
            steps {
                bash ("""
                                func_linkDeps() {
                                    local dependency_path=\$(echo \${1} | sed 's#/\$##g')
                                    rm -rf ${EXTHM_SOURCE_PATH}/\${dependency_path} &&
                                    mkdir -p ${EXTHM_SOURCE_PATH}/\${dependency_path} &&
                                    rm -rf ${EXTHM_SOURCE_PATH}/\${dependency_path} &&
                                    ln -s -f ${EXTHM_TREES_PATH}/\${dependency_path} ${EXTHM_SOURCE_PATH}/\${dependency_path}
                                    if [ \${?} -eq 0 ]
                                    then
                                        echo \""${EXTHM_TREES_PATH}/\${dependency_path} has successfully linked to ${EXTHM_SOURCE_PATH}/\${dependency_path}\""
                                    else
                                        echo \"ln has exited with return \${?},exiting...\"
                                        return \${?}
                                    fi
                                    echo \"Looking for dependencies in \${dependency_path}\"
                                    if [ -f \"${EXTHM_SOURCE_PATH}/\${dependency_path}/${DEPENDENCIES_FILE_NAME}\" ]
                                    then
                                        echo \"Dependencies found, linking dependencies.\"
                                        tmp=\$(jq -r .[].target_path \"${EXTHM_SOURCE_PATH}/\${dependency_path}/${DEPENDENCIES_FILE_NAME}\")
                                        if [ \${?} -ne 0 ]
                                        then
                                            echo \"jq has exited with \${?}, exiting...\"
                                            return \${?}
                                        fi
                                        local target_paths=\${tmp}
                                        for target_path in \${target_paths}
                                        do
                                            if [[ ! "\${target_path}" =~ ^[0-9a-zA-Z_/-]{1,}\$ ]]
                                            then
                                                echo \"Path \${target_path} in dependencies file is not allowed! Exiting...\"
                                                return 1
                                            fi
                                            if [ -d \"${EXTHM_TREES_PATH}/\${target_path}\" ] 
                                            then
                                                if [[ \"\${target_path}\" =~ ^device/ ]] || [[ \"\${target_path}\" =~ ^kernel/ ]] || [[ \"\${target_path}\" =~ ^vendor/ ]]
                                                then
                                                    func_linkDeps \${target_path}
                                                    if [ \${?} -ne 0 ]
                                                    then
                                                        echo \"func_linkDeps has exited with \${?}, exiting...\"
                                                        return \${?}
                                                    fi
                                                else
                                                    echo \"warn: \${target_path} is not started from device/,kernel/ or vendor/, ignoring...\"
                                                fi
                                            else
                                                echo \"warn: \${target_path} not found, ignoring...\"
                                            fi
                                        done
                                    else
                                            echo \"No dependency found in \${dependency_path}\"
                                    fi
                                    return 0
                                }

                                func_linkDeps \"device/${TARGET_MANUFACTOR}/${TARGET_CODE_NAME}\"
                                """, false)
            }
        }
        stage('Build') {
            steps {
                bash ("""cd ${EXTHM_SOURCE_PATH}
                                . build/envsetup.sh
                                rm -rf out/target/product/${TARGET_CODE_NAME}/exthm-*.zip
                                lunch exthm_${TARGET_CODE_NAME}-${TARGET_VARIANT}
                                mka bacon -j${BUILD_THREADS}""", false)
            }
        }
        stage('Upload') {
            steps {
                bash ("""mkdir out
                                cp ${EXTHM_SOURCE_PATH}/out/target/product/${TARGET_CODE_NAME}/exthm-*.zip ./out""", false)
            }
        }
    }

    post {
        always {
            bash ("""
                            func_unlinkDeps() {
                                local dependency_path=\$(echo \${1} | sed 's#/\$##g')
                                echo \"Looking for dependencies in \${dependency_path}\"
                                if [ -f \"${EXTHM_SOURCE_PATH}/\${dependency_path}/${DEPENDENCIES_FILE_NAME}\" ]
                                then
                                    echo \"Dependencies found, removing dependencies.\"
                                    tmp=\$(jq -r .[].target_path \"${EXTHM_SOURCE_PATH}/\${dependency_path}/${DEPENDENCIES_FILE_NAME}\")
                                    if [ \${?} -ne 0 ]
                                    then
                                        echo \"jq has exited with \${?}, exiting...\"
                                        return \${?}
                                    fi
                                    local target_paths=\${tmp}
                                    for target_path in \${target_paths}
                                    do
                                        if [[ ! "\${target_path}" =~ ^[0-9a-zA-Z_/-]{1,}\$ ]]
                                        then
                                            echo \"Path \${target_path} in dependencies file is not allowed! Exiting...\"
                                            return 1
                                        fi
                                        if [[ \"\${target_path}\" =~ ^device/ ]] || [[ \"\${target_path}\" =~ ^kernel/ ]] || [[ \"\${target_path}\" =~ ^vendor/ ]]
                                        then
                                            func_unlinkDeps \${target_path}
                                            if [ \${?} -ne 0 ]
                                            then
                                                echo \"func_unlinkDeps has exited with \${?}, please contact with system administrator\"
                                                return \${?}
                                            fi
                                        else
                                            echo \"warn: \${target_path} is not started from device/,kernel/ or vendor/, ignoring...\"
                                        fi
                                    done
                                else
                                    echo \"No dependency found in \${dependency_path}\"
                                fi
                                rm -f ${EXTHM_SOURCE_PATH}/\${dependency_path}
                                if [ \${?} -eq 0 ]
                                then
                                    echo \"link ${EXTHM_SOURCE_PATH}/\${dependency_path} has successfully removed\"
                                else
                                    echo \"rm has exited with \${?}, please contact with system administrator\"
                                    return \${?}
                                fi
                                return 0
                            }

                            func_unlinkDeps \"device/${TARGET_MANUFACTOR}/${TARGET_CODE_NAME}\"
                            """, false)
            archiveArtifacts artifacts: 'out/*', onlyIfSuccessful: true
            cleanWs()
        }
    }
}
