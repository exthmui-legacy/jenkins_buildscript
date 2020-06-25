pipeline {
    agent {
        label "$AGENT_LABEL"
    }

    environment {
        EXTHM_SOURCE_PATH = "${EXTHM_SOURCE_BASEPATH}/exthm-${TARGET_VERSION}"
    }
    stages {
        stage('Lunch') {
            steps {
                sh label: '', script: '''bash -c "cd ${EXTHM_SOURCE_PATH}
                . build/envsetup.sh
                lunch exthm_${TARGET_CODE_NAME}-${TARGET_VARIANT}"'''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
