def bash(cmd, returnStdout) {
    return sh (script: '#!/bin/bash -e\n'+ cmd, returnStdout: returnStdout)
}

pipeline {
    agent {
        label "$AGENT_LABEL"
    }

    environment {
        EXTHM_SOURCE_PATH = "${EXTHM_SOURCE_BASEPATH}/exthm-${TARGET_VERSION}"
        EXTHM_TREES_PATH = "${EXTHM_TREES_BASEPATH}/exthm-${TARGET_VERSION}"
    }

    stages {
        stage('Link trees to source') {
            steps {
                bash ("""for i in ${EXTHM_TREES_PATH}/{device,kernel,vendor}/*
                                do
                                    ln -s -f \$i \$(echo \$i | sed \"s#^${EXTHM_TREES_PATH}#${EXTHM_SOURCE_PATH}#g\")
                                done""", false)
            }
        }
        stage('Sync Projects') {
            steps {
                bash ("""cd ${EXTHM_SOURCE_PATH}
                repo sync --force-sync""", false)
            }
        }
    }

    post {
        always {
            bash label: '', script: """for i in ${EXTHM_TREES_PATH}/{device,kernel,vendor}/*
                            do
                                rm -rf \$(echo \$i | sed \"s#^${EXTHM_TREES_PATH}#${EXTHM_SOURCE_PATH}#g\")
                            done"""
            cleanWs()
        }
    }
}
