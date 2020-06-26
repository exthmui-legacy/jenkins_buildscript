pipeline {
    agent {
        label "$AGENT_LABEL"
    }

    environment {
        EXTHM_SOURCE_PATH = "${EXTHM_SOURCE_BASEPATH}/exthm-${TARGET_VERSION}"
        EXTHM_TREES_PATH = "${EXTHM_TREES_BASEPATH}/exthm-${TARGET_VERSION}"
        DEPENDENCIES_FILE_NAME = "exthm.dependencies"
    }
    stages {
        stage('Have a breakfast') {
            steps {
                sh label: '', script: '''bash -c "cd ${EXTHM_SOURCE_PATH}
                . build/envsetup.sh
                breakfast ${TARGET_CODE_NAME}"'''
                echo 'Delicious!'
            }
        }
        stage('Move dishes to kitchen') {
            steps {
                sh label: '', script: '''bash -c \"
                                        moveDeps() {
                                            local dependency_path=\\$(echo \\${1} | sed \\\"s/\\\\/\\\$//g\\\")
                                            echo \\\"Looking for dependencies in \\${dependency_path}\\\"
                                            if [ -f \\\"${EXTHM_SOURCE_PATH}/\\${dependency_path}/${DEPENDENCIES_FILE_NAME}\\\" ]
                                            then
                                                echo \\\"Dependencies found, moving dependencies.\\\"
                                                local target_paths=\\$(jq -r .[].target_path \\\"${EXTHM_SOURCE_PATH}/\\${dependency_path}/${DEPENDENCIES_FILE_NAME}\\\")
                                                for target_path in \\${target_paths}
                                                do
                                                    if [ -d \\\"${EXTHM_SOURCE_PATH}/\\${target_path}\\\" ]
                                                    then
                                                        if [[ \\\"\\${target_path}\\\" =~ ^device/ ]] || [[ \\\"\\${target_path}\\\" =~ ^kernel/ ]] || [[ \\\"\\${target_path}\\\" =~ ^vendor/ ]]
                                                        then
                                                            moveDeps \\${target_path}
                                                            if [ \\${?} -ne 0 ]
                                                            then
                                                                echo \\\"moveDeps has exited with \\${?}, exiting...\\\"
                                                                return \\${?}
                                                            fi
                                                        else
                                                            echo \\\"warn: \\${target_path} is not started from device/,kernel/ or vendor/, ignoring...\\\"
                                                        fi
                                                    else
                                                        echo \\\"warn: \\${target_path} not found, ignoring...\\\"
                                                    fi
                                                done
                                            else
                                                echo \\\"No dependency found in \\${dependency_path}\\\"
                                            fi
                                            rm -rf ${EXTHM_TREES_PATH}/\\${dependency_path} &&
                                            mkdir -p ${EXTHM_TREES_PATH}/\\${dependency_path} &&
                                            rm -rf ${EXTHM_TREES_PATH}/\\${dependency_path} &&
                                            mv ${EXTHM_SOURCE_PATH}/\\${dependency_path} ${EXTHM_TREES_PATH}/\\${dependency_path}
                                            if [ \\${?} -eq 0 ]
                                            then
                                                echo \\\"${EXTHM_SOURCE_PATH}/\\${dependency_path} has successfully moved to ${EXTHM_TREES_PATH}/\\${dependency_path}\\\"
                                            else
                                                echo \\\"mv has exited with return \\${?}, exiting...\\\"
                                                return \\${?}
                                            fi
                                            return 0
                                        }

                                        moveDeps "device/${TARGET_MANUFACTOR}/${TARGET_CODE_NAME}"
                                        for i in ${EXTHM_TREES_PATH}/{device,kernel,vendor}/*
                                        do
                                            rm -rf \\$(echo \\$i | sed \\"s#^${EXTHM_TREES_PATH}#${EXTHM_SOURCE_PATH}#g\\")
                                        done
                                        \"'''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
