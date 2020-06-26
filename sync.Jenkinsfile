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
                sh label: '', script: '''bash -c "for i in ${EXTHM_TREES_PATH}/{device,kernel,vendor}/*
                                do
                                    ln -s -f \\$i \\$(echo \\$i | sed \\"s#^${EXTHM_TREES_PATH}#${EXTHM_SOURCE_PATH}#g\\")
                                done"'''
            }
        }
        stage('Sync Projects') {
            steps {
                sh label: '', script: '''bash -c "cd ${EXTHM_SOURCE_PATH}
                repo sync --force-sync"'''
            }
        }
    }

    post {
        always {
            sh label: '', script: '''bash -c "for i in ${EXTHM_TREES_PATH}/{device,kernel,vendor}/*
                            do
                                rm -rf \\$(echo \\$i | sed \\"s#^${EXTHM_TREES_PATH}#${EXTHM_SOURCE_PATH}#g\\")
                            done"'''
            cleanWs()
        }
    }
}
